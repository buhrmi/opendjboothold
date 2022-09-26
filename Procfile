web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
release: bundle exec rake db:migrate
booths: bundle exec rake background:booths