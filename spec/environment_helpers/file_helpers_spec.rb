RSpec.describe EnvironmentHelpers::FileHelpers do
  subject(:env) { ENV }

  describe "#file_path" do
    let(:name) { "FOO" }

    context "with required: true" do
      subject(:file_path) { ENV.file_path(name, required: true) }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }

        it "raises a MissingVariableError" do
          expect { file_path }.to raise_error(EnvironmentHelpers::MissingVariableError, /not supplied/)
        end
      end

      context "when the environment value is set" do
        with_env("FOO" => "bar")
        it { is_expected.to eq Pathname.new("bar") }
      end
    end

    context "without a default specified" do
      subject(:file_path) { ENV.file_path(name) }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to be_nil }
      end

      context "when the environment value is set" do
        with_env("FOO" => "bar")
        it { is_expected.to eq Pathname.new("bar") }
      end
    end

    context "with a default specified" do
      subject(:file_path) { ENV.file_path(name, default: "foo") }

      context "when the environment value is not set" do
        it { is_expected.to eq Pathname.new("foo") }
      end

      context "when the environment value is set" do
        with_env("FOO" => "bar")
        it { is_expected.to eq Pathname.new("bar") }
      end
    end
  end
end
