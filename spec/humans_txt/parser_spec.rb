# encoding: utf-8

require_relative "../spec_helper"

describe HumansTxt::Parser do
  subject { HumansTxt::Parser }

  let(:c7)          { s(IO.read('spec/fixtures/c7.se')).parse           }
  let(:tv4)         { s(IO.read('spec/fixtures/www.tv4.se')).parse      }
  let(:straypeople) { s(IO.read('spec/fixtures/straypeople.it')).parse  }
  let(:hero99)      { s(IO.read('spec/fixtures/hero99.com.br')).parse   }
  let(:cb)          { s(IO.read('spec/fixtures/www.camisetas-baratas.com')).parse   }
  let(:webcat)      { s(IO.read('spec/fixtures/webcatbcn.com')).parse   }

  describe "parse" do
    it "parses the teams section" do
      c7[:team].size.must_equal 1
      tv4[:team].size.must_equal 11
      straypeople[:team].size.must_equal 2
      cb[:team].size.must_equal 3
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
  end
end
