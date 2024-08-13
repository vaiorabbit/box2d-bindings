import box2d_parser, box2d_generator

if __name__ == "__main__":

    ctx = box2d_parser.ParseContext('math_function.h')
    box2d_parser.execute(ctx)

    box2d_generator.sanitize(ctx)

    box2d_generator.generate(ctx,
                             setup_method_name = 'math_function')
