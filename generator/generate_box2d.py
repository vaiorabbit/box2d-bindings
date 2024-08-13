import box2d_parser, box2d_generator

if __name__ == "__main__":

    ctx = box2d_parser.ParseContext('box2d.h')
    box2d_parser.execute(ctx)

    box2d_generator.sanitize(ctx)
    box2d_generator.generate(ctx,
                             setup_method_name = 'box2d')
