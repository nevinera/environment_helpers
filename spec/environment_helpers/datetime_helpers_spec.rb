RSpec.describe EnvironmentHelpers::DatetimeHelpers do
  subject(:env) { ENV }

  describe "#date" do
    let(:name) { "FOO" }
    let(:options) { {} }
    subject(:date) { env.date(name, **options) }

    context "with required: true" do
      let(:options) { {required: true} }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }

        it "raises a MissingVariableError" do
          expect { date }.to raise_error(
            EnvironmentHelpers::MissingVariableError,
            /not supplied/
          )
        end
      end

      context "when the environment value is set" do
        with_env("FOO" => "2023-04-25")
        it { is_expected.to eq(Date.new(2023, 4, 25)) }

        context "to an invalid value" do
          with_env("FOO" => "hello")

          it "raises a MissingVariableError" do
            expect { date }.to raise_error(
              EnvironmentHelpers::InvalidDateText,
              /inappropriate content/
            )
          end
        end
      end
    end

    context "with default set" do
      let(:options) { {default: Date.new(2000, 1, 1)} }

      context "to a value of the wrong type" do
        let(:options) { {default: 5} }

        it "raises a BadDefault error" do
          expect { date }.to raise_error(
            EnvironmentHelpers::BadDefault,
            /inappropriate default/i
          )
        end
      end

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to eq(Date.new(2000, 1, 1)) }
      end

      context "when the environment value is set" do
        with_env("FOO" => "2023-04-25")
        it { is_expected.to eq(Date.new(2023, 4, 25)) }
      end
    end

    context "with default not set" do
      before { expect(options).not_to include(:default) }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to be_nil }
      end

      context "when the environment value is set" do
        with_env("FOO" => "2023-04-25")
        it { is_expected.to eq(Date.new(2023, 4, 25)) }
      end
    end

    context "with other formats supplied" do
      def self.it_parses_date_as(text:, format:, result:)
        context "for supplied text '#{text}' and format '#{format}'" do
          let(:options) { {format: format} }
          with_env("FOO" => text)
          it { is_expected.to eq(result) }
        end
      end

      it_parses_date_as text: "2023-4-12", format: "%Y-%m-%d", result: Date.new(2023, 4, 12)
      it_parses_date_as text: "2023/4/12", format: "%Y/%m/%d", result: Date.new(2023, 4, 12)
      it_parses_date_as text: "1/2/3", format: "%m/%d/%Y", result: Date.new(3, 1, 2)
      it_parses_date_as text: "hello", format: "%m/%d/%Y", result: nil
      it_parses_date_as text: "2023-4-12", format: "hello", result: nil
    end
  end

  describe "#date_time" do
    let(:name) { "FOO" }
    let(:options) { {} }
    subject(:date_time) { env.date_time(name, **options) }

    context "with required: true" do
      let(:options) { {required: true} }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }

        it "raises a MissingVariableError" do
          expect { date_time }.to raise_error(
            EnvironmentHelpers::MissingVariableError,
            /not supplied/
          )
        end
      end

      context "when the environment value is set" do
        with_env("FOO" => "2023-04-25T13:44:59.75+07:30")
        it { is_expected.to eq(DateTime.new(2023, 4, 25, 13, 44, 59.75, "+7:30")) }

        context "to an invalid value" do
          with_env("FOO" => "hello")

          it "raises a MissingVariableError" do
            expect { date_time }.to raise_error(
              EnvironmentHelpers::InvalidDateTimeText,
              /inappropriate content/
            )
          end
        end
      end
    end

    context "with default set" do
      let(:options) { {default: DateTime.new(2000, 1, 1, 4, 5, 6, "+7")} }

      context "to a value of the wrong type" do
        let(:options) { {default: Date.new(2023, 1, 2)} }

        it "raises a BadDefault error" do
          expect { date_time }.to raise_error(
            EnvironmentHelpers::BadDefault,
            /inappropriate default/i
          )
        end
      end

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to eq(options[:default]) }
      end

      context "when the environment value is set" do
        with_env("FOO" => "2023-04-25T14:22:33+02")
        it { is_expected.to eq(DateTime.new(2023, 4, 25, 14, 22, 33, "+2")) }
      end
    end

    context "with default not set" do
      before { expect(options).not_to include(:default) }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to be_nil }
      end

      context "when the environment value is set" do
        with_env("FOO" => "2023-04-25T03:13:56Z")
        it { is_expected.to eq(DateTime.new(2023, 4, 25, 3, 13, 56, "UTC")) }
      end
    end

    context "with other formats supplied" do
      def self.it_parses_datetime_as(text:, format:, result:)
        context "for supplied text '#{text}' and format '#{format}'" do
          let(:options) { {format: format} }
          with_env("FOO" => text)
          it { is_expected.to eq(result) }
        end
      end

      context "for :unix format" do
        it_parses_datetime_as text: "1684200709", format: :unix, result: DateTime.new(2023, 5, 16, 1, 31, 49, "UTC")
        it_parses_datetime_as text: "hello", format: :unix, result: nil
      end

      context "for :iso8601 format" do
        it_parses_datetime_as text: "2023-05-15T23:25:24-04:00", format: :iso8601, result: DateTime.new(2023, 5, 15, 23, 25, 24, "-4")
        it_parses_datetime_as text: "2023-05-15T23:25:24.75-04:00", format: :iso8601, result: DateTime.new(2023, 5, 15, 23, 25, 24.75, "-4")
        it_parses_datetime_as text: "hello", format: :iso8601, result: nil
      end

      context "for string formats" do
        it_parses_datetime_as text: "2023.05.15.23.25.25", format: "%Y.%m.%d.%H.%M.%S", result: DateTime.new(2023, 5, 15, 23, 25, 25, "UTC")
        it_parses_datetime_as text: "hello", format: "%Y.%m.%d.%H.%M.%S", result: nil
      end

      context "with a bad format" do
        let(:options) { {format: :notreal} }
        with_env("FOO" => "2023-05-15T23:25:24-04:00")

        it "raises a BadFormat exception" do
          expect { date_time }.to raise_error(EnvironmentHelpers::BadFormat, /date_time requires either/)
        end
      end
    end
  end
end
