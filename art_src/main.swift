import Foundation

let args = CommandLine.arguments
let outDir = args.count > 1 ? args[1] : "./out"
let mode = args.count > 2 ? args[2] : "all"
try? FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)

func stamp(_ what: String) {
    FileHandle.standardError.write(("  " + what + "\n").data(using: .utf8)!)
}

if mode == "icon" || mode == "all" { stamp("icon"); renderCathedralIcon(outDir) }
if mode == "cathedrals" || mode == "all" {
    for c in cathedralPlates { stamp("cath " + c.slug); drawCathedralPlate(c, dir: outDir) }
}
if mode == "elements" || mode == "all" {
    for e in elementPlates { stamp("elem " + e.slug); drawElementPlate(e, dir: outDir) }
}
if mode == "lessons" || mode == "all" {
    for l in lessonSheets { stamp("lesson " + l.slug); drawLessonSheet(l, dir: outDir) }
}
if mode == "scenes" || mode == "all" {
    for sc in siteScenes { stamp("scene " + sc.slug); drawSiteScene(sc, dir: outDir) }
}
stamp("done")
