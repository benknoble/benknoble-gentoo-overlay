# Ben Knoble's Gentoo overlay

Install with `eselect` (`emerge --ask app-eselect/eselect-repository`):

```
eselect repository add benknoble-overlay git https://github.com/benknoble/benknoble-gentoo-overlay
```

## Special notes

- `dev-vcs/git-credential-1password` depends on [jaredallard's packaged
  `op-cli-bin`](https://github.com/jaredallard/overlay/tree/main); set up their
  repository first.
