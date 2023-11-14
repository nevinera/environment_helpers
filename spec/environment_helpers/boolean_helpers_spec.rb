RSpec.describe EnvironmentHelpers::BooleanHelpers do
  subject(:env) { ENV }

  describe "#boolean" do
    let(:name) { "FOO" }
    let(:options) { {} }
    subject(:boolean) { env.boolean(name, **options) }
    without_env "ENVIRONMENT_HELPERS_TRUTHY_STRINGS", "ENVIRONMENT_HELPERS_FALSEY_STRINGS"

    def self.it_handles(text, as:)
      context "when handling environment value '#{text}'" do
        with_env("FOO" => text)
        it { is_expected.to eq(as) }
      end
    end

    %w[true yes on enabled enable allow t y 1 ok okay].each { |text| it_handles(text, as: true) }
    %w[false no off disabled disable deny f n 0 nope].each { |text| it_handles(text, as: false) }

    context "if not required" do
      let(:options) { {default: true} }
      ["meh", "maybe", "?", "tru", "!"].each { |text| it_handles(text, as: true) }
    end

    context "if required" do
      let(:options) { {required: true} }

      ["meh", "maybe", "?", "tru", "!"].each do |text|
        context "when handling environment value '#{text}'" do
          with_env("FOO" => text)

          it "raises InvalidBooleanText" do
            expect { boolean }.to raise_error(
              EnvironmentHelpers::InvalidBooleanText,
              /inappropriate content/
            )
          end
        end
      end
    end

    context "with ENVIRONMENT_HELPERS_TRUTHY_STRINGS supplied" do
      before { ENV.instance_variable_set(:@_truthy_strings, nil) }
      after { ENV.instance_variable_set(:@_truthy_strings, nil) }
      let(:options) { {default: false} }
      with_env "ENVIRONMENT_HELPERS_TRUTHY_STRINGS" => "foo,bar,baz"
      %w[foo bar baz].each { |text| it_handles(text, as: true) }
      %w[true yes false no off].each { |text| it_handles(text, as: false) }
    end

    context "with ENVIRONMENT_HELPERS_FALSEY_STRINGS supplied" do
      before { ENV.instance_variable_set(:@_falsey_strings, nil) }
      after { ENV.instance_variable_set(:@_falsey_strings, nil) }
      let(:options) { {default: true} }
      with_env "ENVIRONMENT_HELPERS_FALSEY_STRINGS" => "foo,bar,baz"
      %w[foo bar baz].each { |text| it_handles(text, as: false) }
      %w[true yes false no off].each { |text| it_handles(text, as: true) }
    end

    context "with both FOO and BAR set" do
      with_env "FOO" => "nope", "BAR" => "no", "BAZ" => "deny"

      it "caches the values of truthy_strings and falsey_strings across ENV.boolean calls" do
        allow(ENV).to receive(:fetch).and_call_original
        ENV.instance_variable_set(:@_falsey_strings, nil)
        ENV.instance_variable_set(:@_truthy_strings, nil)

        ENV.boolean("BAR", required: false)
        expect(ENV).to have_received(:fetch).with("ENVIRONMENT_HELPERS_TRUTHY_STRINGS", anything).once
        expect(ENV).to have_received(:fetch).with("ENVIRONMENT_HELPERS_FALSEY_STRINGS", anything).once

        ENV.boolean("FOO", required: false)
        ENV.boolean("BAZ", required: false)
        expect(ENV).to have_received(:fetch).with("ENVIRONMENT_HELPERS_TRUTHY_STRINGS", anything).once
        expect(ENV).to have_received(:fetch).with("ENVIRONMENT_HELPERS_FALSEY_STRINGS", anything).once
      end
    end

    context "with required: true" do
      let(:options) { {required: true} }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }

        it "raises a MissingVariableError" do
          expect { boolean }.to raise_error(
            EnvironmentHelpers::MissingVariableError,
            /not supplied/
          )
        end
      end

      context "when the environment value is set" do
        with_env("FOO" => "true")
        it { is_expected.to eq(true) }
      end
    end

    context "without a default specified" do
      let(:options) { {} }

      context "when the env value is set" do
        with_env("FOO" => "true")
        it { is_expected.to eq(true) }
      end

      context "when the env value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to be_nil }
      end
    end

    context "with a default specified" do
      let(:options) { {default: true} }

      context "but with an inappropriate value" do
        let(:options) { {default: 4} }

        it "raises a BadDefault error" do
          expect { boolean }.to raise_error(EnvironmentHelpers::BadDefault, /inappropriate default/i)
        end
      end

      context "and the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to eq(true) }
      end

      context "and the environment value is set" do
        with_env("FOO" => "false")
        it { is_expected.to eq(false) }
      end
    end
  end
end
