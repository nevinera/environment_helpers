RSpec.describe EnvironmentHelpers::RangeHelpers do
  subject(:env) { ENV }

  describe "#integer_range" do
    let(:name) { "FOO" }
    let(:options) { {} }
    subject(:integer_range) { ENV.integer_range(name, **options) }

    context "when required: true" do
      let(:options) { {required: true} }

      context "and the key is supplied" do
        with_env("FOO" => "52-63")
        it { is_expected.to eq(52..63) }

        context "but has invalid content" do
          with_env("FOO" => "hello")

          it "raises a MissingVariableError" do
            expect { integer_range }.to raise_error(
              EnvironmentHelpers::InvalidRangeText,
              /inappropriate content/
            )
          end
        end
      end

      context "and the environment variable is not supplied" do
        before { expect(ENV["FOO"]).to be_nil }

        it "raises a MissingVariableError" do
          expect { integer_range }.to raise_error(
            EnvironmentHelpers::MissingVariableError,
            /not supplied/
          )
        end
      end
    end

    context "without a default specified" do
      let(:options) { {} }

      context "when the environment variable is present" do
        with_env("FOO" => "58..61")
        it { is_expected.to eq(58..61) }
      end

      context "when the environment variable is not present" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to be_nil }
      end
    end

    context "with a default specified" do
      let(:options) { {default: (91..93)} }

      context "but of the wrong type" do
        let(:options) { {default: "91"} }

        it "raises a BadDefault error" do
          expect { integer_range }.to raise_error(
            EnvironmentHelpers::BadDefault,
            /inappropriate default/i
          )
        end
      end

      context "with the wrong type of endpoint" do
        let(:options) { {default: ("a".."c")} }

        it "raises a BadDefault error" do
          expect { integer_range }.to raise_error(
            EnvironmentHelpers::BadDefault,
            /invalid endpoint for default range/i
          )
        end
      end

      context "when the environment variable is present" do
        with_env("FOO" => "58..62")
        it { is_expected.to eq(58..62) }

        context "but not actually an integer" do
          with_env("FOO" => "hello")
          it { is_expected.to eq(91..93) }
        end
      end

      context "when the environment variable is not present" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to eq(91..93) }
      end
    end

    context "for various formats" do
      context "with a dash" do
        with_env("FOO" => "3-5")
        it { is_expected.to eq(3..5) }
      end

      context "with two dots" do
        with_env("FOO" => "3..5")
        it { is_expected.to eq(3..5) }
      end

      context "with three dots" do
        with_env("FOO" => "3...5")
        it { is_expected.to eq(3...5) }
        it { is_expected.not_to be_cover(5) }
      end

      context "with missing bound" do
        with_env("FOO" => "3..")
        it { is_expected.to be_nil }
      end
    end
  end
end
