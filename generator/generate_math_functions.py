import box2d_parser, box2d_generator

if __name__ == "__main__":

    ctx = box2d_parser.ParseContext('math_functions.h')
    box2d_parser.execute(ctx)

    ctx.decl_functions['b2Rot_GetAngle'] = None

    box2d_generator.sanitize(ctx)

    box2d_generator.generate(ctx,
                             setup_method_name = 'math_functions')
