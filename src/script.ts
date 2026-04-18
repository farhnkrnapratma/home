window.addEventListener("scroll", (): void => {
  const progressBar = document.getElementById(
    "scroll-progress"
  ) as HTMLElement | null

  if (progressBar) {
    const winScroll: number =
      document.body.scrollTop || document.documentElement.scrollTop
    const height: number =
      document.documentElement.scrollHeight -
      document.documentElement.clientHeight

    if (height > 0) {
      const scrolled: number = (winScroll / height) * 100
      progressBar.style.width = `${scrolled}%`
    }
  }
})
