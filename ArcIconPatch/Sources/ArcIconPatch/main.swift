import AppKit
import AssetCatalogWrapper
import Foundation

@main
enum ArcIconPatch {
    static func main() {
        let args = CommandLine.arguments
        guard args.count >= 3 else {
            FileHandle.standardError.write(
                Data("usage: \(args[0]) <Assets.car> <icon.icns>\n".utf8))
            exit(1)
        }

        let carURL = URL(fileURLWithPath: args[1])
        let icnsPath = args[2]

        guard let nsImage = NSImage(contentsOfFile: icnsPath) else {
            fputs("Cannot load icns: \(icnsPath)\n", stderr)
            exit(1)
        }

        var bestRep: NSImageRep?
        var bestW = 0
        for rep in nsImage.representations {
            let w = rep.pixelsWide
            if w >= bestW {
                bestW = w
                bestRep = rep
            }
        }
        guard let rep = bestRep else {
            fputs("No image representations in icns\n", stderr)
            exit(1)
        }

        guard let bitmap = rep as? NSBitmapImageRep else {
            fputs("Expected bitmap representation in icns\n", stderr)
            exit(1)
        }
        guard let cgImage = bitmap.cgImage else {
            fputs("Could not get CGImage from icns\n", stderr)
            exit(1)
        }

        do {
            let (catalog, collection) = try AssetCatalogWrapper.shared.renditions(forCarArchive: carURL)
            var patched = 0
            var failures: [String] = []

            for (_, rends) in collection {
                for r in rends {
                    let n = r.name
                    guard n.hasPrefix("AppIcon") else { continue }
                    guard r.type == .image || r.type == .icon else { continue }
                    guard r.type.isEditable else { continue }
                    do {
                        try catalog.editItem(r, fileURL: carURL, to: .image(cgImage), isAlphaAllowed: true)
                        patched += 1
                        print("Patched: \(n)")
                    } catch {
                        failures.append("\(n): \(error.localizedDescription)")
                    }
                }
            }

            for f in failures {
                fputs("Failed: \(f)\n", stderr)
            }
            print("Done. Patched \(patched) rendition(s).")
            if patched == 0 {
                exit(2)
            }
        } catch {
            fputs("Catalog error: \(error)\n", stderr)
            exit(1)
        }
    }
}
