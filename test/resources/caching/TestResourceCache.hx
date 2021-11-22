package resources.caching;

import resources.parsers.ParserOption;
import resources.caching.ResourceCache;
import haxe.ds.Option;
import utest.Assert;
import utest.Test;
using Lambda;

class TestResourceCache extends Test {

    private var cache:ResourceCache<ParserOption, Int>;

    function setup():Void {
        this.cache = new ResourceCache();
    }

    /**
     * Tests that cache can retrieve values by name only.
     */
    function testCacheRetrieveByName():Void {
        this.cache.set(Name("asdf"), 34);
        this.cache.set(Name("zxcv"), 35);
        
        final actual:Option<Int> = this.cache.get(Name("asdf"));

        Assert.isTrue(actual.match(Some(34)));
    }

    /**
     * Tests that cache can retrieve values by name and a single option.
     */
     function testCacheRetrieveByNameAndSingleOption():Void {
        this.cache.set(Name("zxcv"), 16);
        this.cache.set(NameAndOption("asdf", UseMaterial(false)), 15);
        
        final actual:Option<Int> = this.cache.get(NameAndOption("asdf", UseMaterial(false)));

        Assert.isTrue(actual.match(Some(15)));
    }

    /**
     * Tests that cache can retrieve values by name and multiple options.
     */
     function testCacheRetrieveByNameAndMultipleOptions():Void {
        this.cache.set(NameAndOptions("zxcv", [UseMaterial(false), UseMaterial(false)]), 100);
        this.cache.set(NameAndOptions("asdf", [UseMaterial(false), UseMaterial(true)]), 120);
        
        final actual:Option<Int> = this.cache.get(
            NameAndOptions("zxcv", [UseMaterial(false), UseMaterial(false)]));

        Assert.isTrue(actual.match(Some(100)));
    }
}