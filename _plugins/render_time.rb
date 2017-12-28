

=begin

Show the time when the post was generated.
That time changes every time you call "jekyll serve".

=end
module Jekyll
    class RenderTimeTag < Liquid::Tag

        def initialize(tag_name, text, tokens)
            super
            @text = text
        end

        def render(context)
            "#{@text} #{Time.now}"
        end
    end
end

Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTag)


=begin

Show the last modification time of the current post file.

=end
module Jekyll
    class ModificationTimeTag < Liquid::Tag
        def render(context)
            page = context.environments.first["page"]
            return File.mtime(page.path)
        end
    end
end

Liquid::Template.register_tag('last_modified', Jekyll::ModificationTimeTag)


=begin

Add the property 'last_modified' to all pages and sites.

=end
module Jekyll
    class LastModifiedAtGenerator < Jekyll::Generator
        def generate(site)
            site.posts.docs.each do |item|
                item.data['last_modified'] = File.mtime(item.path)
            end
            site.pages.each do |item|
                item.data['last_modified'] = File.mtime(item.path)
            end
        end
    end
end
