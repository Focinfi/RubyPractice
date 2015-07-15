require 'user_defined_nameservers'

RSpec.describe "User-defined nameservers" do
  describe MyResolvers do
    describe "resolver" do
      let(:my_resolvers) { MyResolvers.new }
      context "one server" do
        it "has a single_resolvers array" do
          servers = my_resolvers.resolver.single_resolvers.map(&:server)
          expect(servers).to eq ['8.8.8.8']
        end
      end

      context "multi-server" do
        my_resolvers = MyResolvers.new(['8.8.8.8', '223.5.5.5'])
        it "has a single_resolvers array" do
          servers = my_resolvers.resolver.single_resolvers.map(&:server)
          expect(servers).to eq %w(8.8.8.8 223.5.5.5)
        end
      end

      context "wrong server" do
        my_resolvers = MyResolvers.new(%w(1.1.1.1))
        it "raise a Dnsruby::ResolvTimeout exception" do
          expect { my_resolvers.resolver.query("focinfi.wang") }.to raise_error Dnsruby::ResolvTimeout
        end
      end

      context "wrong record type" do
        it "raise a ArgumentError exception" do
          expect { my_resolvers.resolver.query("focinfi.wang", "XX") }.to raise_error ArgumentError
        end
      end
      context "wrong domain" do
        it "rainse a Dnsruby::NXDomain or a Dnsruby::ResolvTimeout exception" do
          #expect { my_resolvers.resolver.query("focinfiiixx.wang") }.to raise_error
        end
      end

    end
  end
end
