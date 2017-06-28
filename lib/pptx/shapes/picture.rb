module PPTX
  module Shapes
    class Picture < Shape
      DEFAULT_BORDER_COLOR  = '000000'
      DEFAULT_BORDER_WIDTH  = 1

      def initialize(transform, relationship_id, formatting={})
        super(transform)
        @relationship_id = relationship_id
        @formatting = formatting
      end

      def base_xml
        # TODO replace cNvPr descr, id and name
        """
        <p:pic xmlns:a='http://schemas.openxmlformats.org/drawingml/2006/main'
               xmlns:p='http://schemas.openxmlformats.org/presentationml/2006/main'>
            <p:nvPicPr>
                <p:cNvPr descr='test_photo.jpg' id='2' name='Picture 1'/>
                <p:cNvPicPr>
                    <a:picLocks noChangeAspect='1'/>
                </p:cNvPicPr>
                <p:nvPr/>
            </p:nvPicPr>
            <p:blipFill>
                <a:blip r:embed='REPLACEME'/>
                <a:stretch>
                    <a:fillRect/>
                </a:stretch>
            </p:blipFill>
            <p:spPr>
            </p:spPr>
        </p:pic>
        """
      end

      def build_node
        base_node.tap do |node|
          node.xpath('.//a:blip', a: DRAWING_NS).first['r:embed'] = @relationship_id
          if @formatting[:border]
            border_color = @formatting[:border].fetch(:color, DEFAULT_BORDER_COLOR)
            border_width = @formatting[:border].fetch(:width, DEFAULT_BORDER_WIDTH)
            node.xpath('.//p:spPr', p: Presentation::NS).first.add_child build_border(border_color, border_width)
          end
        end
      end
    end
  end
end
