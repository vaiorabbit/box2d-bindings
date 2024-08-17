import box2d_parser, box2d_generator

if __name__ == "__main__":

    ctx = box2d_parser.ParseContext('base.h')
    box2d_parser.execute(ctx)

    # TODO Prepare platform-specific b2Timer implementation

    box2d_generator.sanitize(ctx)
    box2d_generator.generate(ctx,
                             setup_method_name = 'base')
