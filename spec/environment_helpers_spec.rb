RSpec.describe EnvironmentHelpers do
  subject(:env) { ENV }

  describe "#string" do
    let(:name) { "FOO" }

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
end
