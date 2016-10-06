require 'rails_helper'

RSpec.describe PostsController, type: :request do
  let!(:post1) { Post.create(title: "我是標題", content: "我是內容") }

  describe "#index" do
    subject! { get "/posts" }

    it { expect(response).to be_success }
    it { expect(response.body).to match("我是標題")}
  end

  describe "#new" do
    subject { get "/posts/new" }

    it { expect(subject).to eq(200) } 
    it { expect(subject).to render_template("new") }
  end

  describe "#edit" do
    subject { get "/posts/#{post1.id}/edit" }

    it { expect(subject).to render_template("edit") }
  end

  describe "#create" do
    let(:params) { { title: "標題", content: "內容" } }
    subject { post "/posts", post: params }

    it { expect { subject }.to change { Post.count }.by(1) }
    it { expect(subject).to redirect_to("/posts/#{Post.last.id}") }
  end

  describe "#update" do
    let(:params) { { title: "今日天氣", content: "讀書天"} }
    subject! { put "/posts/#{post1.id}", post: params }

    it { expect(post1.reload.content).to eq("讀書天") } #錯在哪？
    it { expect(subject).to redirect_to("/posts/#{Post.last.id}") }
  end

  describe "#create" do
    subject { post "/posts", post: params }

    context "success" do
      let(:params) { { title: "標題", content: "內容"} }
      it { expect { subject }.to change { Post.count }.by(1) }
      it { expect(subject).to redirect_to("/posts/#{Post.last.id}") }
    end

    context "fail" do
      let(:params) { { title: "", content: "內容"} }      
      before { subject }

      it { expect(Post.count).to eq(1) }
      it { expect(response).to render_template("new") }
      it { expect(flash[:alert]).to eq("新增失敗") }
    end
  end

  describe "#destroy" do
    subject { delete "/posts/#{post1.id}" }

    it { expect { subject }.to change { Post.count }.by(-1) }
    it { expect(subject).to redirect_to("/posts") }
  end


  #refactory let!(:post)
end
