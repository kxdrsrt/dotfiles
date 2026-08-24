# Jackett setup checklist

## One-time setup

- [ ] Run `nixre` - installs Jackett via Homebrew and drops `jackett.py` into qBittorrent's engines folder
- [ ] Run `brew services start jackett` - starts Jackett and generates API key
- [ ] Open http://127.0.0.1:9117 and add indexers
- [ ] Run `nixre` again - activation script reads the API key from Jackett config and writes `jackett.json`
- [ ] Open qBittorrent - verify Jackett appears in the Search tab sources

## Verify config file

`jackett.json` lives at:

```
~/Library/Application Support/qBittorrent/nova3/engines/jackett.json
```

Contents should look like:

```json
{
  "api_key": "<auto-filled by nixre after first start>",
  "url": "http://127.0.0.1:9117",
  "tracker_first": false,
  "thread_count": 20
}
```

## Day-to-day

- [ ] Jackett runs as a brew service - starts automatically at login after `brew services start jackett`
- [ ] To stop: `brew services stop jackett`
- [ ] Update indexers / check status at http://127.0.0.1:9117

## Notes

- API key is in the top-right corner of the Jackett UI
- If `jackett.json` gets out of date (wrong key etc.), delete it and run `nixre` to regenerate it
- Plugin file (`jackett.py`) is always re-downloaded on `nixre` so it stays up to date
