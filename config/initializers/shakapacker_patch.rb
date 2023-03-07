if defined? Webpacker::Compiler
  shakapacker_compile_lock_path = Module.new do
    def open_lock_file
      lock_file_name = config.root_path.join("tmp", "shakapacker.lock")
      File.open(lock_file_name, File::CREAT) do |lf|
        return yield lf
      end
    end
  end

  Webpacker::Compiler.prepend shakapacker_compile_lock_path
end