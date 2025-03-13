module Jekyll
  class VersionGenerator < Generator
    priority :high
    safe true

    def generate(site)
      site.data["version"] = {}
      #if File.exist?(".git")
      #  begin
      #    git_desc = %x( git describe --always --dirty )
      #    encoded_git_desc = git_desc.encode('UTF-8', invalid: :replace, undef: :replace)
      #    duplicated_git_desc = encoded_git_desc.dup
      #    site.data["version"]["git"] = duplicated_git_desc.strip
      #  rescue Encoding::UndefinedConversionError => e
      #    puts "Encoding error (git): #{e.message}"
      #    site.data["version"]["git"] = %x( git describe --always --dirty ).strip #try original
      #  end
      #end
      site.data["version"]["build_date"] = %x( date +%s )
    end
  end
end