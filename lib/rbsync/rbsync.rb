
module RBSync
  class RBSync

    # define the flags
    %w{
      --verbose
      --quiet
      --no-motd
      --checksum
      --archive
      --no-OPTION
      --recursive
      --relative
      --no-implied-dirs
      --backup
      --backup-dir=DIR
      --suffix=SUFFIX
      --update
      --inplace
      --append
      --append-verify
      --dirs
      --links
      --copy-links
      --copy-unsafe-links
      --safe-links
      --copy-dirlinks
      --keep-dirlinks
      --hard-links
      --perms
      --executability
      --chmod=CHMOD
      --acls
      --xattrs
      --owner
      --group
      --devices
      --specials

      --times
      --omit-dir-times
      --super
      --fake-super
      --sparse
      --dry-run
      --whole-file
      --one-file-system
      --block-size=SIZE
      --rsh=COMMAND
      --rsync-path=PROGRAM
      --existing
      --ignore-existing
      --remove-source-files
      --del
      --delete
      --delete-before
      --delete-during
      --delete-delay
      --delete-after
      --delete-excluded
      --ignore-errors
      --force
      --max-delete=NUM
      --max-size=SIZE
      --min-size=SIZE
      --partial
      --partial-dir=DIR
      --delay-updates
      --prune-empty-dirs
      --numeric-ids
      --timeout=SECONDS
      --contimeout=SECONDS
      --ignore-times
      --size-only
      --modify-window=NUM
      --temp-dir=DIR
      --fuzzy
      --compare-dest=DIR
      --copy-dest=DIR
      --link-dest=DIR
      --compress
      --compress-level=NUM
      --skip-compress=LIST
      --cvs-exclude
      --filter=RULE

      --exclude=PATTERN
      --exclude-from=FILE
      --include=PATTERN
      --include-from=FILE
      --files-from=FILE
      --from0
      --protect-args
      --address=ADDRESS
      --port=PORT
      --sockopts=OPTIONS
      --blocking-io
      --stats
      --8-bit-output
      --human-readable
      --progress

      --itemize-changes
      --out-format=FORMAT
      --log-file=FILE
      --log-file-format=FMT
      --password-file=FILE
      --list-only
      --bwlimit=KBPS
      --write-batch=FILE
      --only-write-batch=FILE
      --read-batch=FILE
      --protocol=NUM
      --iconv=CONVERT_SPEC
      --checksum-seed=NUM
      --ipv4
      --ipv6
      --version
      --help
    }.each do |flag|
      flag.gsub!(/^--/, '')
      flag = flag.split '='

      raise "a flag should be non-empty and contain only one equals sign" if ! [1, 2].include? flag.size

      name = flag[0]
      name.gsub!(/-/, '_')
      name.gsub!(/^(\d+)/, '_\1')

      # define the read accessor
      define_method name do
        instance_variable_get "@#{name}"
      end

      # if the flag has two components, it contains an equals sign, and accepts a value
      # else, it has only one and doesn't contain an equals sign, which makes it a boolean flag
      if flag.size == 2
        
      elsif flag.size == 1
        alias_method "#{name}?".to_sym, name

        define_method "#{name}=" do |value|
          instance_variable_set "@#{name}", value
        end
        define_method "#{name}!" do
          self.send "#{name}=", true
          Option.new self, name
        end

      else
        raise "a flag should contain only one equals sign"
      end
    end

    def no
      Negator.new self
    end

  end
end