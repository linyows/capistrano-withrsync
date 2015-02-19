RSpec.describe 'Capistrano with Rsync' do
  describe '# bundle exec cap test deploy' do
    it 'successful' do
      Dir.chdir ENV['TID_BASE_PATH'] do
        _, _, ex = cmd 'bundle exec cap test deploy'
        expect(ex.exitstatus).to eq 0
      end
    end

    it 'puts some string' do
      Dir.chdir ENV['TID_BASE_PATH'] do
        out, _, _ = cmd 'bundle exec cap test deploy'
        expect(out).to include 'Running /usr/bin/env rsync -e \'ssh -p'
      end
    end
  end
end
