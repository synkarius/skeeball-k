package macros;

import haxe.macro.Context;
import haxe.macro.Expr;
using Lambda;

@:extern 
class Record {
    public static macro function build():Array<Field> {
        // get macro context stuff
        final fields:Array<Field> = Context.getBuildFields();
        final position:Position = Context.currentPos();

        // 
        final constructorParams:Array<FunctionArg> = [];
        final constructorAssignmentExpressions:Array<Expr> = [];

        final getters:Array<Field> = [];
        // 
        for (field in fields) {
            switch (field.kind) {
            case FVar(complexType, expression):
                // Each field should get a constructor param and a constructor assignment expression.
                constructorParams.push({
                    name: field.name, 
                    type: complexType, 
                    opt: false, 
                    value: null
                });
                constructorAssignmentExpressions.push(macro $p{["this", field.name]} = $i{field.name});

                // Make field private, only accessible via getter.
                field.access.push(APrivate);
                getters.push({
                    name: "get" + capitalize(field.name),
                    access: [APublic],
                    pos: position,
                    kind: FFun({
                        args: [],
                        expr: macro return $p{["this", field.name]},
                        params: [],
                        ret: complexType
                    })
                });
            default:
            }
        }
        // add constructor
        fields.push({
            name: "new",
            access: [APublic],
            pos: position,
            kind: FFun({
                args: constructorParams,
                expr: macro $b{constructorAssignmentExpressions},
                params: [],
                ret: null
            })
        });

        // add getters
        for (i in 0...getters.length) {
            fields.push(getters[i]);
        }
        
        return fields;
    }

    private static function capitalize(s:String):String {
        return s.substr(0, 1).toUpperCase() + s.substr(1);
    }
}