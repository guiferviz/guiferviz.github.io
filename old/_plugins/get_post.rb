
=begin

Create a new tag called get_post that returns a post object.

That object is very useful becouse allows you to get all the
post information from any source file of your site. You can
access information like difficulty, description...

=end
module Jekyll
    class FontAwesomeTag < Liquid::Tag
        def render(context)
            if args = parse_args(@markup.strip)
                post_id = args[0]
                extra = args[1]

                posts = context["site"]["posts"]
                posts.each do |p|
                    if p.id.end_with? post_id
                        case extra
                        when "icon"
                            if context["site"]["difficulties"]
                                return p["difficulty_icon"]
                            end
                            return ""
                        when "link"
                            if context["site"]["difficulties"]
                                icon = p["difficulty_icon"]
                                return "#{icon} [#{p['title']}](#{p.url})"
                            end
                            return "[#{p['title']}](#{p.url})"
                        when "modification_time"
                            return File.mtime(p.path)
                        when "title"
                            return p["title"]
                        else
                            return p.url
                        end
                    end
                end
            else
                raise ArgumentError.new <<-eos
                Syntax error in tag 'get_post' while parsing the following markup:
                #{@markup}
                Valid syntax:
                {% get_post <post_id> [modification_time|title|link|icon] %}
                eos
            end
        end

        private

        def parse_args(input)
            matched = input.match(/\A(\S+) ?(\S+)?\Z/)
            [matched[1].to_s.strip, matched[2].to_s.strip] if matched && matched.length >= 3
        end

    end
end

Liquid::Template.register_tag("get_post", Jekyll::FontAwesomeTag)
