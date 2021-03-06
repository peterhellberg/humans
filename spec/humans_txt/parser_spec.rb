# encoding: utf-8

require_relative "../spec_helper"

describe HumansTxt::Parser do
  subject { HumansTxt::Parser }

  let(:humanstxt)   { s(IO.read('spec/fixtures/humanstxt.org')).parse   }
  let(:c7)          { s(IO.read('spec/fixtures/c7.se')).parse           }
  let(:tv4)         { s(IO.read('spec/fixtures/www.tv4.se')).parse      }
  let(:straypeople) { s(IO.read('spec/fixtures/straypeople.it')).parse  }
  let(:hero99)      { s(IO.read('spec/fixtures/hero99.com.br')).parse   }
  let(:cb)          { s(IO.read('spec/fixtures/www.camisetas-baratas.com')).parse   }
  let(:webcat)      { s(IO.read('spec/fixtures/webcatbcn.com')).parse   }
  let(:github)      { s(IO.read('spec/fixtures/github.com')).parse      }
  let(:tito)        { s(IO.read('spec/fixtures/tito.io')).parse         }
  let(:perishable)  { s(IO.read('spec/fixtures/perishablepress.com')).parse }

  describe "parse" do
    it "parses the teams section" do
      humanstxt[:team].size.must_equal 5
      c7[:team].size.must_equal 1
      tv4[:team].size.must_equal 11
      straypeople[:team].size.must_equal 2
      cb[:team].size.must_equal 3
      webcat[:team].size.must_equal 4
      github[:team].size.must_equal 130
    end

    it "parses humanstxt.org correctly" do
      t = humanstxt[:team].first

      t[:role].must_equal 'Chef'
      t[:name].must_equal 'Juanjo Bernabeu'
      t[:contact].must_equal 'hello@humanstxt.org'
      t[:from].must_equal 'Barcelona, Catalonia, Spain'

      humanstxt[:thanks].size.must_equal 11
    end

    it "parses c7.se correctly" do
      t = c7[:team].first

      t[:role].must_equal 'Developer'
      t[:name].must_equal 'Peter Hellberg'
      t[:twitter].must_equal 'https://twitter.com/peterhellberg'
      t[:location].must_equal 'Stockholm, Sweden'

      c7[:site][:microformats].must_equal ['hCard', 'Open Graph']
    end

    it "parses www.tv4.se correctly" do
      t = tv4[:team].first

      t[:role].must_equal 'CTO'
      t[:name].must_equal 'Per Åström'
      t[:twitter].must_equal 'https://twitter.com/perkovich'
      t[:location].must_equal 'Stockholm, Sweden'

      tv4[:site][:components].must_equal ["Ruby on Rails", "jQuery", "Memcached"]
    end

    it "parses straypeople.it correctly" do
      t = straypeople[:team].last

      t[:role].must_equal 'Creative and Visual Designer'
      t[:name].must_equal 'Oriana Personeni'
      t[:contact].must_equal 'laori@straypeople.it'
      t[:twitter].must_equal 'https://twitter.com/strayori'
      t[:from].must_equal 'Bergamo, Italy'

      site = straypeople[:site]

      site[:standards].must_equal ["HTML5", "CSS3"]
    end

    it "parses hero99.com.br correctly" do
      t = hero99[:team].last

      t[:role].must_equal    'Creative Planner'
      t[:name].must_equal    'Guilherme Nagüeva'
      t[:twitter].must_equal 'https://twitter.com/nagueva'
      t[:from].must_equal    'Curitiba, Paraná, Brazil'

      thanks = hero99[:thanks]

      thanks.size.must_equal 3
    end

    it "parses www.camisetas-baratas.com correctly" do
      t = cb[:team].first

      t[:role].must_equal 'CEO'
      t[:name].must_equal 'Angel Fernandez'
      t[:site].must_equal 'http://www.camisetas-baratas.com'
      t[:twitter].must_equal 'https://twitter.com/angelcamisetas'
      t[:location].must_equal 'Barcelona'

      cb[:thanks].first[:role].must_equal "Logo design"
    end

    it "parses webcatbcn.com correctly" do
      t = webcat[:team].first

      webcat[:thanks].first[:role].must_equal 'Rest of the #webcat team'
      webcat[:site][:components][1].must_equal 'FitText.js'
    end

    it "parses github.com correctly" do
      t = github[:team]

      t[2][:name].must_equal "PJ Hyett"
      t[4][:name].must_equal "Tekkub"
      t[8][:name].must_equal "Zach Holman"

      t[128][:name].must_equal :UNKNOWN

      t[16][:role].must_equal "Octocat Geneticist"
      t[18][:role].must_equal "Robots! With Lasers!"
      t[22][:role].must_equal nil
      t[44][:role].must_equal "Pretty Pretty Man"

      github[:team].map { |e| e[:location] }.uniq.size.must_equal 72
    end

    it "parses tito.io correctly" do
      tito[:city].must_equal "Dublin"
      tito[:country].must_equal "Ireland"
      tito[:emails].must_equal ["support@tito.io"]

      tito[:team][3][:name].must_equal "Kilian McMahon"
      tito[:team][5][:url].must_equal "https://github.com/paulca"
    end

    it "parser perishablepress.com correctly" do
      ps = perishable[:site]

      ps[:site_name].must_equal "Perishable Press"
      ps[:site_url].must_equal "http://perishablepress.com/"
      ps[:contact].must_equal "http://perishablepress.com/press/contact/"
      ps[:location].must_equal ["Washington State", "US"]
    end
  end
end
