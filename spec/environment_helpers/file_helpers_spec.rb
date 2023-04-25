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
        context "but it does not point to an existing file" do
          with_env("FOO" => "bar")
          it { is_expected.to be_nil }
        end

        context "but it does not point to an existing file" do
          with_env("FOO" => __FILE__)
          it { is_expected.to eq Pathname.new(__FILE__) }
        end
      end
    end

    context "without a default specified" do
      subject(:file_path) { ENV.file_path(name) }

      context "when the environment value is not set" do
        before { expect(ENV["FOO"]).to be_nil }
        it { is_expected.to be_nil }
      end

      context "when the environment value is set" do
        context "to a pathname that does not exist" do
          with_env("FOO" => "bar")
          it { is_expected.to be_nil }
        end

        context "to a pathname that does exist" do
          with_env("FOO" => __FILE__)
          it { is_expected.to eq Pathname.new(__FILE__) }
        end
      end
    end

    context "with a default specified" do
      subject(:file_path) { ENV.file_path(name, default: "foo") }

      context "when the environment value is not set" do
        it { is_expected.to be_nil }
      end

      context "when the environment value is set" do
        context "to a pathname that does not exist" do
          with_env("FOO" => "bar")
          it { is_expected.to be_nil }
        end

        context "to a pathname that does exist" do
          with_env("FOO" => __FILE__)
          it { is_expected.to eq Pathname.new(__FILE__) }
        end
      end
    end
  end
end
