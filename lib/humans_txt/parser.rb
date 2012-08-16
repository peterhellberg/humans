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
      found_first_team_member = false

      data = {
        team: [],
        site: {}
      }

      cs = ''
      cf = ''
      ct = {}

      f = txt.split("\n").each_with_object(data) do |l,d|
        if m = l.match(/^\/\* ([A-Z]+) \*\/$/)
          cs = m[1].downcase.to_sym
        else
          if cs == :team
            if l.match(/^$/) && !ct.empty?
              d[:team] << ct
              ct = {}
              found_first_team_member = true
            else
              if m = l.strip.match(/(.+?):\s*(.+)/)
                if ct.empty?
                  ct[:name] = m[2]
                  ct[:role] = m[1]
                else
                  cf = m[1].gsub(' ', '_').downcase.to_sym
                  cv = m[2]
                  cv = cv.sub('@', 'https://twitter.com/') if cf == :twitter

                  ct[cf] = cv
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

              d[:site][cf] = o
            end
          end
        end

        if found_first_team_member && d[:team].empty? && !ct.empty?
          d[:team] << ct
        end
      end.tap { |h|
        h.delete(:site) if h[:site].empty?
      }

      if f[:team].empty? && !ct.empty?
        f[:team] << ct
      elsif f[:team].empty?
        f.tap { |h| h.delete(:team) }
      end

      f
    rescue ArgumentError => e
      { error: e }
    end
  end
end
