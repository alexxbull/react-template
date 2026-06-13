# Template for React + React Compiler (rust) + Typescript (7.0) + tsgo

Template repo using nix + devenv to set up a React development environment with the following:

- React
- React Compiler (rust version)
- TypesSript 7.0 (supports tsgo compiler)
- typescript-go (typescript go compiler)
- oxc + oxlint + oxfmt + tsgolint
- pnpm
- Nodejs
- Vite

# Requirements

- [nix](https://github.com/nixos/nix) or [nix-darwin](https://github.com/nix-darwin/nix-darwin)
- [devenv](https://devenv.sh/)

# Install

Install the required software linked in [Requirements](#requirements), clone the repo, and follow these [instructions](https://devenv.sh/auto-activation/) to auto-activate the environment:

1. Open terminal
2. Append `eval "$(devenv hook bash)"` to your shell startup file and reload your terminal
   - `echo 'eval "$(devenv hook bash)"' >> ~/.bashrc && source ~/.bashrc`
3. Navigate to the cloned repo
   - `cd ~/react-template`
4. Grant devenv permission to auto load the dev environment
   - `devenv allow`
5. Navigate out of project directory
   - `cd ..`
6. Navigate back into project directory to auto load the dev environment
   - `cd -`
7. Start developing

# Config files

[oxc-config.nix](oxc-config.nix) creates [.oxlintrc.json](.oxlintrc.json), [vite.config.ts](vite.config.ts), and [.vscode/settings.json](.vscode/settings.json). If you want to edit these files, you should edit their configuration in `oxc-config.nix` and not the files directly. Changes to `.oxlintrc.json` and `.vscode/settings.json` will automatically apply when you reload your dev environment but `vite.config.ts` must be deleted prior to reloading your dev environment for the new changes to apply.
