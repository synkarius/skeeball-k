package resources.groups;

import utest.Assert;
import utest.Test;
using Lambda;

class TestPhysicsAssets extends Test {

    private var resources:Map<String, String>;

    function setup():Void {
        this.resources = this.readAllPhysicsResourcesFromDisk("assets/physics");
    }

    /**
     * Tests that this test can find the physics assets in order to test them in other tests.
     */
    function testThatPhysicsAssetsExist():Void {
        Assert.isTrue(this.resources.count() > 0);
    }

    /**
     * Tests that all physics resources provide vertices in sets of 3 rather than not 4-vertex square faces.
     */
    function testTrianglesAreValid():Void {
        final failures:Array<String> = [];

        for (filename in this.resources.keys()) {
            final fileContent:String = this.resources.get(filename);
            final lines:Array<Array<String>> = fileContent.split("\n")
                .filter(line -> line.indexOf("f ") == 0)
                .map(f -> f.split("f ")[1])
                .map(f -> f.split(" "))
                .filter(f -> f.length != 3);
            if (lines.length > 0) {
                failures.push(filename);
            }
        }
        failures.sort(Reflect.compare);
        Assert.isTrue(failures.count() == 0, "failing resources: \n" + failures.join(",\n "));
    }

    /**
     * @return Map<String, String> the map of filenames to file contents
     */
    private function readAllPhysicsResourcesFromDisk(directory:String):Map<String, String> {
        final resources:Map<String, String> = new Map<String, String>();
        for (file in sys.FileSystem.readDirectory(directory)) {
            if (file.indexOf(".obj") == -1) {
                continue;
            }
            final path:String = haxe.io.Path.join([directory, file]);
            final content:String = sys.io.File.getContent(path);
            final cleaned:String = StringTools.replace(content, "\r", "");
            resources.set(path, cleaned);
        }
        return resources;
    }
}