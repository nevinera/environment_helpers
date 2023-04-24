RSpec.describe EnvironmentHelpers::NumericHelpers do
  subject(:env) { ENV }

  describe "#integer" do
    let(:name) { "FOO" }
    let(:options) { {} }
    subject(:integer) { ENV.integer(name, **options) }

    context "when required: true" do
      let(:options) { {required: true} }

      context "and the key is supplied" do
        with_env("FOO" => "52")
        it { is_expected.to eq(52) }
      end

      context "and the environment variable is not supplied" do
        before { expect(ENV["FOO"]).to be_nil }

        it "raises a MissingVariableError" do
          expect { integer }.to raise_error(
            EnvironmentHelpers::MissingVariableError,
            /not supplied/
          )
        end
      end
    end

    context "without a default specified" do
      let(:options) { {} }

      context "when the environment variable is present" do
        with_env("FOO" => "58")
        it { is_expected.to eq(58) }
      end

      context "when the environment variable is not present" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to be_nil }
      end
    end

    context "with a default specified" do
      let(:options) { {default: 91} }

      context "but of the wrong type" do
        let(:options) { {default: "91"} }

        it "raises a BadDefault error" do
          expect { integer }.to raise_error(
            EnvironmentHelpers::BadDefault,
            /inappropriate default/i
          )
        end
      end

      context "when the environment variable is present" do
        with_env("FOO" => "58")
        it { is_expected.to eq(58) }

        context "but not actually an integer" do
          # It produces "hello".to_i, which is zero.
          with_env("FOO" => "hello")
          it { is_expected.to eq(0) }
        end
      end

      context "when the environment variable is not present" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to eq(91) }
      end
    end
  end
end
