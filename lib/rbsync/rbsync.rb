
module RBSync
  class RBSync

    def initialize from=nil, to=nil
      @options = {}

      self.from = from
      self.to = to
    end

=begin
    0      Success

    1      Syntax or usage error

    2      Protocol incompatibility

    3      Errors selecting input/output files, dirs

    4      Requested action not supported: an attempt was made  to  manipu-
           late  64-bit files on a platform that cannot support them; or an
           option was specified that is supported by the client and not  by
           the server.

    5      Error starting client-server protocol

    6      Daemon unable to append to log-file

    10     Error in socket I/O

    11     Error in file I/O

    12     Error in rsync protocol data stream

    13     Errors with program diagnostics

    14     Error in IPC code

    20     Received SIGUSR1 or SIGINT

    21     Some error returned by waitpid()

    22     Error allocating core memory buffers

    23     Partial transfer due to error

    24     Partial transfer due to vanished source files

    25     The --max-delete limit stopped deletions

    30     Timeout in data send/receive

    35     Timeout waiting for daemon connection
=end

    # define the flags
    (%w{
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
    }).each do |flag|
      flag.gsub!(/^--/, '')
      flag = flag.split '='

      raise "a flag should be non-empty and contain only one equals sign" if ! [1, 2].include? flag.size

      flag_name = name = flag[0]
      name.gsub!(/-/, '_')
      name.gsub!(/^8/, 'eight')
      name.gsub!(/^(\d+)/, '_\1')

      # define the read accessor
      define_method name do
        @options[flag_name]
      end

      # if the flag has two components, it contains an equals sign, and accepts a value
      # else, it has only one and doesn't contain an equals sign, which makes it a boolean flag
      if flag.size == 2
        argument = flag[1]

        define_method "#{name}=" do |value|
          @options[flag_name] = value
        end
      elsif flag.size == 1
        alias_method "#{name}?".to_sym, name

        define_method "#{name}=" do |value|
          raise ArgumentError, "value must be either true, false, or nil" if ! [true, false, nil].include?(value)
          @options[flag_name] = value
        end
        define_method "#{name}!" do
          self.send "#{name}=", true
          Option.new self, name
        end
      else
        raise "a flag should contain only one equals sign"
      end
    end

    attr_accessor :from_host, :from_user, :from_path
    attr_accessor :to_host, :to_user, :to_path

    def from
      @from || build_path(from_user, from_host, from_path)
    end
    attr_writer :from

    def to
      @to || build_path(to_user, to_host, to_path)
    end
    attr_writer :to

    def no
      Negator.new self
    end

    # returns the rysnc command that would be executed
    def command
      c = ""
      c << "rsync"
      @options.each_pair do |flag, value|
        next if value.nil?

        c << " --#{flag}"

        if value.is_a? String
          c << "='#{value}'"
        end
      end

      c << " #{from} #{to}"

      c
    end

  protected
    def build_path user, host, path
      if ! user.nil? && ! host.nil? && ! path.nil?
        "#{user}@#{host}:#{path}"
      elsif user.nil? && host.nil? && ! path.nil?
        path
      else
        raise ArgumentError, "you must either set the host, user, and path, or just the path"
      end
    end
  end
end