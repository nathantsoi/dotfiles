# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if ! command -v eza >/dev/null 2>&1 && ! command -v exa >/dev/null 2>&1 && $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi
