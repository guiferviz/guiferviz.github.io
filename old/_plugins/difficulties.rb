

DIFFICULTIES_NAME = {
    -1 => "Sin clasificar",
    0 => "Null",
    1 => "Fácil",
    2 => "Atrevido",
    3 => "Insensato",
    4 => "WTF??"
}

DIFFICULTIES_ICON = {
    -1 => "",
    0 => "fa fa-battery-empty general",
    1 => "fa fa-battery-quarter facil",
    2 => "fa fa-battery-half medio",
    3 => "fa fa-battery-three-quarters dificil",
    4 => "fa fa-battery-full chungo"
}

DIFFICULTIES_DESC = {
    -1 => "",
    0 => "Posts de cultura general, sencillos de entender, casi sin matemáticas.",
    1 => "Pocas matemáticas, explicaciones paso a paso y casi no requiere conocimientos previos.",
    2 => "Artículos con conceptos básicos/medios pero que no cuentan con explicaciones tan detalladas, se da por sentado que el lector conoce varios de los conceptos nombrados.",
    3 => "Requiere de conocimientos matemáticos más avanzados y se da por hecho que se conocen muchos otros conceptos nombrados en el post.",
    4 => "Artículos que hablan de temas tan complejos que no entiendo ni yo. Así que no creo que escriba sobre algo que no sé... de todas formas me reservo este nivel por lo que pueda pasar."
}


=begin
    
Add the property 'difficulties' to the site variable.
Add the property 'difficulty_icon' to all pages and posts.
Add the property 'difficulty' to all pages and posts that does not
have a valid value.

=end
module Jekyll
    class DifficultiesGenerator < Jekyll::Generator
        def generate(site)
            site.data['difficulties'] = DIFFICULTIES_NAME
            site.posts.docs.each do |item|
                if item.data["difficulty"]
                    item.data['difficulty_icon'] = get_icon(item.data["difficulty"])
                else
                    item.data["difficulty"] = -1
                end
            end
            site.pages.each do |item|
                if item.data["difficulty"]
                    item.data['difficulty_icon'] = get_icon(item.data["difficulty"])
                else
                    item.data["difficulty"] = -1
                end
            end
        end
    end
end



=begin
    
Liquid tag that returns the difficulty icon.

=end
module Jekyll
    class DiffIconTag < Liquid::Tag
        def render(context)
            if args = parse_args(@markup.strip)
                # Evaluate variable
                diff_id = eval("#{context[args[0]]}")

                return get_icon(diff_id)
            else
                raise ArgumentError.new <<-eos
                Syntax error in tag 'get_diff_icon' while parsing the following markup:
                #{@markup}
                Valid syntax:
                {% get_diff_icon <difficulty_level> %}
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

Liquid::Template.register_tag("get_diff_icon", Jekyll::DiffIconTag)

def get_icon(diff)
    return "<span id='#{diff}' title='Dificultad: #{DIFFICULTIES_NAME[diff]}' class='#{DIFFICULTIES_ICON[diff]}'></span>"
end



=begin
    
Liquid tag that returns the difficulty name.

=end
module Jekyll
    class DiffNameTag < Liquid::Tag
        def render(context)
            if args = parse_args(@markup.strip)
                # Evaluate variable
                diff_id = eval("#{context[args[0]]}")

                return get_name(diff_id)
            else
                raise ArgumentError.new <<-eos
                Syntax error in tag 'get_diff_name' while parsing the following markup:
                #{@markup}
                Valid syntax:
                {% get_diff_name <difficulty_level> %}
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

Liquid::Template.register_tag("get_diff_name", Jekyll::DiffNameTag)

def get_name(diff)
    return DIFFICULTIES_NAME[diff]
end


=begin
    
Liquid tag that returns the difficulty description.

=end
module Jekyll
    class DiffDescTag < Liquid::Tag
        def render(context)
            if args = parse_args(@markup.strip)
                # Evaluate variable
                diff_id = eval("#{context[args[0]]}")

                return get_desc(diff_id)
            else
                raise ArgumentError.new <<-eos
                Syntax error in tag 'get_diff_desc' while parsing the following markup:
                #{@markup}
                Valid syntax:
                {% get_diff_desc <difficulty_level> %}
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

Liquid::Template.register_tag("get_diff_desc", Jekyll::DiffDescTag)

def get_desc(diff)
    return DIFFICULTIES_DESC[diff]
end
