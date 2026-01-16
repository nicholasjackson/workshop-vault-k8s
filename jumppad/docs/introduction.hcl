resource "chapter" "introduction" {
  title = "Introduction"

  tasks = {}

  page "overview" {
    content = file("./introduction/overview.mdx")
  }

  page "architecture" {
    content = file("./introduction/architecture.mdx")
  }
}
