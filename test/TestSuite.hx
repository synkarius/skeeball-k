package;

import resources.groups.TestPhysicsAssets;
import resources.caching.TestResourceCache;
import utest.Runner;
import utest.ui.Report;

class TestSuite {
    
    public static function main():Void {
      var runner = new Runner();
      runner.addCase(new TestPhysicsAssets());
      runner.addCase(new TestResourceCache());
      Report.create(runner);
      runner.run();
    }
  }