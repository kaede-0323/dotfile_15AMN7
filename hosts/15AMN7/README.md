# 15AMN7 migration target

Canonical NixOS switch target for this machine:

```bash
nh os switch . -H IDEA_15AMN7
```

Rollback to previous generation:

```bash
sudo /run/current-system/bin/switch-to-configuration switch
```

Notes:

- `IDEA_15AMN7` now uses `hosts/15AMN7/home-manager-minimal.nix` as the default Home Manager composition.
- Optional features should be added explicitly via `hosts/15AMN7/home-manager.nix` (or another profile import), not by default.
