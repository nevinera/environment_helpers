RSpec.describe EnvironmentHelpers::BooleanHelpers do
  subject(:env) { ENV }

  describe "#boolean" do
    let(:name) { "FOO" }
    let(:options) { {} }
    subject(:boolean) { env.boolean(name, **options) }

    described_class::TRUTHY_STRINGS.each do |text|
      context "when handling environment value '#{text}'" do
        with_env("FOO" => text)
        it { is_expected.to eq(true) }
      end
    end

    described_class::FALSEY_STRINGS.each do |text|
      context "when handling environment value '#{text}'" do
        with_env("FOO" => text)
        it { is_expected.to eq(false) }
      end
    end

    ["meh", "maybe", "?", "tru", "!"].each do |text|
      context "when handling environment value '#{text}'" do
        with_env("FOO" => text)

        context "if required" do
          let(:options) { {required: true} }

          it "raises InvalidBooleanText" do
            expect { boolean }.to raise_error(
              EnvironmentHelpers::InvalidBooleanText,
              /inappropriate content/
            )
          end
        end

        context "if not required" do
          let(:options) { {default: true} }
          it { is_expected.to eq(true) }
        end
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
