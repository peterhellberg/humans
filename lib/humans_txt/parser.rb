# encoding: utf-8

module HumansTxt
  class Parser
    attr_reader :txt

    def initialize(txt)
      @txt = txt
    end

    def self.parse(txt)
      new(txt).parse
    end

    def parse
      data = {
        team:   [],
        thanks: [],
        site:   {}
      }

      cs = ''
      cf = ''
      ct = {}
      th = {}

      f = txt.split("\n").each_with_object(data) do |l,d|
        if m = l.strip.match(/\/\* ([A-Z]+) \*\/$/)
          cs = m[1].downcase.to_sym
        else
          if cs == :team
            if l.strip.match(/^$/) && !ct.empty?
              d[:team] << ct
              ct = {}
            else
              #raise Exception, l.lstrip.inspect if l.match(/Otto/)

              if m = l.match(/^\s\s\s$/)
                if ct.empty?
                  ct[:name] = :UNKNOWN
                end
              elsif m = l.strip.match(/(.+?):\s*(.+)/)
                if ct.empty?
                  ct[:role] = m[1]
                  ct[:name] = m[2]
                else
                  cf = m[1].
                    gsub(' ', '_').
                    downcase.
                    gsub('e-mail', 'contact').
                    gsub('email', 'contact').
                    to_sym

                  cv = m[2]

                  cv = cv.sub('@', 'https://twitter.com/') if cf == :twitter
                  cv = cv.sub(' [at] ', '@').sub('[at]', '@') if cf == :contact

                  ct[cf] = cv
                end
              elsif m = l.strip.match(/(.+?)\s*\((.+)\)$/)
                if ct.empty?
                  ct[:role] = m[2]
                  ct[:name] = m[1]
                end
              elsif m = l.lstrip.match(/^(.+?)\s+$/)
                if ct.empty?
                  ct[:name] = m[1]
                end
              end
            end
          end

          if cs == :alumni
            d[:alumni] != []

            if l.strip.match(/^$/) && !ct.empty?
              d[:alumni] << ct
              ct = {}
            else
              #raise Exception, l.lstrip.inspect if l.match(/Otto/)

              if m = l.match(/^\s\s\s$/)
                if ct.empty?
                  ct[:name] = :UNKNOWN
                end
              elsif m = l.strip.match(/(.+?):\s*(.+)/)
                if ct.empty?
                  ct[:role] = m[1]
                  ct[:name] = m[2]
                else
                  cf = m[1].
                    gsub(' ', '_').
                    downcase.
                    gsub('e-mail', 'contact').
                    gsub('email', 'contact').
                    to_sym

                  cv = m[2]

                  cv = cv.sub('@', 'https://twitter.com/') if cf == :twitter
                  cv = cv.sub(' [at] ', '@').sub('[at]', '@') if cf == :contact

                  ct[cf] = cv
                end
              elsif m = l.strip.match(/(.+?)\s*\((.+)\)$/)
                if ct.empty?
                  ct[:role] = m[2]
                  ct[:name] = m[1]
                end
              elsif m = l.lstrip.match(/^(.+?)\s+$/)
                if ct.empty?
                  ct[:name] = m[1]
                end
              end
            end
          end

          if cs == :thanks
            if l.strip.match(/^$/) && !th.empty?
              d[:thanks] << th
              th = {}
            else
              if m = l.strip.match(/(.+?):\s*(.+)/)
                if th.empty?
                  th[:role] = m[1]
                  th[:name] = m[2]
                else
                  cf = m[1].gsub(' ', '_').downcase.to_sym
                  cv = m[2]

                  cv = cv.sub('@', 'https://twitter.com/') if cf == :twitter

                  th[cf] = cv
                end
              end
            end
          end

          if cs == :site
            if m = l.strip.match(/(.+):\s{1,}(.+)/)
              cf = m[1].gsub(' ', '_').downcase.to_sym

              if m[2].include?(', ')
                cv = m[2].split(', ')
              else
                cv = m[2]

                if m = cv.strip.match(/^<(.+)>$/)
                  cv = m[1]
                end

                if m = cv.match(/(.+){0,1} <(.+)>/)
                  cv = m[1].nil?? m[2] : { m[1] => m[2] }
                end
              end

              d[:site][cf] = cv
            end

            if m = l.match(/^\s{#{cf.length+2},}(.+)/)
              if m2 = m[1].match(/(.+){0,1} <(.+)>/)
                cv2 = m2[1].nil?? m2[2] : { m2[1] => m2[2] }
              end

              o = [d[:site][cf]].flatten << cv2

              d[:site][cf] = o.compact unless cf.empty?
            end
          end
        end

      end.tap { |h|
        h.delete(:site) if h[:site].empty?
        h.delete(:thanks) if h[:thanks].empty?
      }

      if f[:team].empty? && !ct.empty?
        f[:team] << ct
      elsif f[:team].any? && ct.any?
        f[:team] << ct
      elsif f[:team].empty?
        f.tap { |h| h.delete(:team) }
      end

      # Try to find some information at least (tito.io)
      if f.empty? && !txt.empty? && txt != "{}"
        # Retrieve the team by looking for rows in the format
        #
        # "Name: <URL>"
        #
        txt.scan(/^([\w\s'-]+):? (https?:\/\/.+\..+)$/) do |name, url|
          (f[:team] ||= []) << { name: name.strip, url: url.strip }
        end

        # Find all email adresses
        if (emails = txt.scan(/\S+@\S+/)).any?
          f[:emails] = emails
        end

        # Find city and country
        if txt.match(/in (?<city>\S+), (?<country>\S+) by/m)
          f[:city]    = $~[:city]
          f[:country] = $~[:country]
        end
      end

      # Last resort
      if f.empty? && !txt.empty? && txt != "{}"
        f = { text: txt }
      end

      f
    rescue ArgumentError => e
      { error: e }
    end
  end
end
