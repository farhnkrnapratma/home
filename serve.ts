const SOURCE_DIR = "./src"

function isSafePath(pathname: string) {
  return (
    pathname.startsWith("/") &&
    !pathname.includes("\0") &&
    !pathname.includes("..") &&
    !pathname.includes("\\")
  )
}

function resolvePathnameToFile(pathname: string) {
  if (pathname.endsWith("/")) return `${SOURCE_DIR}${pathname}index.html`
  return `${SOURCE_DIR}${pathname}`
}

async function fileResponse(filePath: string) {
  const file = Bun.file(filePath)
  if (!(await file.exists())) return null

  return new Response(file, {
    headers: {
      "Content-Type": file.type || "application/octet-stream"
    }
  })
}

const server = Bun.serve({
  port: 3000,
  async fetch(req) {
    const url = new URL(req.url)
    const pathname = decodeURIComponent(url.pathname)

    if (!isSafePath(pathname)) {
      return new Response("Bad Request", { status: 400 })
    }

    if (pathname === "/") {
      const home = await fileResponse(`${SOURCE_DIR}/index.html`)
      if (home) return home
    }

    const mapped = resolvePathnameToFile(pathname)
    const resp = await fileResponse(mapped)
    if (resp) return resp

    const asDirIndex = await fileResponse(`${SOURCE_DIR}${pathname}/index.html`)
    if (asDirIndex) return asDirIndex

    return new Response("Not Found", { status: 404 })
  }
})

console.log(`Server running at http://localhost:${server.port}`)
