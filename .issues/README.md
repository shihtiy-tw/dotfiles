# Issues

Issue tracking for this repo, in [git-issue](https://github.com/dspinellis/git-issue)
format: issues are plain files committed alongside the code, so they are versioned,
reviewable in a diff, and readable offline.

## Read this first: the tool is not installed here

`git/gitconfig:24` defines the alias as:

```
issue = !/home/ubuntu/toolkit/git-issue/git-issue.sh
```

That path does not exist on this machine, so **every `git issue` command below currently
fails** with `cannot exec ... No such file or directory`. Nothing named `git-issue` is on
`PATH` either, and the script is not vendored in this repo. To use it, install upstream and
repoint the alias:

```bash
git clone https://github.com/dspinellis/git-issue ~/toolkit/git-issue
git config --global alias.issue '!'"$HOME/toolkit/git-issue/git-issue.sh"
```

(Upstream also supports a system-wide `make install`, which needs privileges.)

The tracker is **already initialized** — do not run `git issue init` against it.

## Reading the issues without the tool

The data is plain text, which is the point of the format. To list every issue and its
state from a bare shell:

```bash
for d in .issues/issues/*/*/; do
    printf '%s  [%s]  %s\n' \
        "$(basename "$(dirname "$d")")$(basename "$d")" \
        "$(grep -xE 'open|closed' "$d/tags")" \
        "$(head -1 "$d/description")"
done
```

## On-disk layout

```text
.issues/
├── config                  # empty — no GitHub/GitLab provider is configured
├── templates/
│   ├── description
│   └── comment
└── issues/
    └── <first 2 hex>/      # an issue ID is a 40-hex sha split across two levels,
        └── <next 38 hex>/  #   so 48/ed47bb… is issue 48ed47bb…
            ├── description # line 1 = summary, blank line, then the body
            └── tags        # one per line
```

`tags` is where **state lives**: a literal `open` or `closed` line sits alongside the free
tags. The free tags in use are `make`, `testing`, `ci`, `termux`.

Note there is no nested `.issues/.git`. This tracker was created with `git issue init -e`,
so issue data is committed into the dotfiles repo itself. Upstream's separate
issue-repository model — `git issue push` / `pull` / `clone` — therefore does not apply
here; issues move when you push this repo.

## Commands actually used to maintain this

```bash
git issue new [-s "summary"]     # create a local issue  (NOT `create`)
git issue list                   # OPEN issues only
git issue list -a                # all issues, including closed
git issue show <issue-id>
git issue tag <issue-id> <tag>...
git issue edit <issue-id>
git issue close <issue-id>
```

Two gotchas worth stating plainly:

- **`git issue create` is not how you create an issue.** It exists upstream, but it means
  "create this existing local issue in the configured GitHub/GitLab repo" and needs
  provider credentials. Use `new`.
- **`git issue list` hides closed issues.** One of the six issues here is closed and is
  invisible without `-a`.

`git issue assign` and `git issue comment` are available but have never been used in this
tracker — there are no `assignee` files and no `comments/` directories on disk. Likewise
the import/export features have no provider configuration behind them (`config` is empty).
