RSpec.describe EnvironmentHelpers::StringHelpers do
  subject(:env) { ENV }

  describe "#string" do
    let(:name) { "FOO" }

    context "with required: true" do
      subject(:string) { ENV.string(name, required: true) }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }

        it "raises a KeyError" do
          expect { string }.to raise_error(EnvironmentHelpers::MissingVariableError, /not supplied/)
        end
      end

      context "when the environment value is set" do
        with_env("FOO" => "bar")
        it { is_expected.to eq("bar") }
      end
    end

    context "without a default specified" do
      subject(:string) { ENV.string(name) }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to be_nil }
      end

      context "when the environment value is set" do
        with_env("FOO" => "bar")
        it { is_expected.to eq("bar") }
      end
    end

    context "with a default specified" do
      subject(:string) { ENV.string(name, default: "foo") }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to eq("foo") }
      end

      context "when the environment value is set" do
        with_env("FOO" => "bar")
        it { is_expected.to eq("bar") }
      end
    end
  end

  describe "#symbol" do
    let(:name) { "FOO" }

    context "with required: true" do
      subject(:symbol) { ENV.symbol(name, required: true) }

      context "when the env value is set" do
        with_env("FOO" => "bar")
        it { is_expected.to eq(:bar) }
      end

      context "when the env value is not set" do
        before { expect(ENV["FOO"]).to be_nil }

        it "raises a KeyError" do
          expect { symbol }.to raise_error(EnvironmentHelpers::MissingVariableError, /not supplied/)
        end
      end
    end

    context "without a default specified" do
      subject(:string) { ENV.symbol(name) }

      context "when the env value is set" do
        with_env("FOO" => "bar")
        it { is_expected.to eq(:bar) }
      end

      context "when the env value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to be_nil }
      end
    end

    context "with a default specified" do
      let(:default) { :baz }
      subject(:symbol) { ENV.symbol(name, default: default) }

      context "of the wrong type" do
        let(:default) { "bar" }

        it "raises a BadDefault error" do
          expect { symbol }.to raise_error(EnvironmentHelpers::BadDefault, /inappropriate default/i)
        end
      end

      context "when the env value is set" do
        with_env("FOO" => "bar")
        it { is_expected.to eq(:bar) }
      end

      context "when the env value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to eq(:baz) }
      end
    end
  end
end
