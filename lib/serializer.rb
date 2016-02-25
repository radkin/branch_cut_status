# save the report for instantaneous consumption
class Serializer
  require_relative 'reports'
  attr_accessor :result_deploy, :result_review, :version
  def create_record
    # instantiate deploy report
    deploy          = Reports.new
    deploy.version  = version
    deploy.jtype    = 'deploy'
    result_deploy   = deploy.gather
    File.open("public/result_deploy-#{version}.bin", 'w+') \
      { |f| f.write(Marshal.dump(result_deploy)) }
    # instantiate review report
    review          = Reports.new
    review.version  = version
    review.jtype    = 'review'
    result_review   = review.gather
    File.open("public/result_review-#{version}.bin", 'w+') \
      { |f| f.write(Marshal.dump(result_review)) }
  end
end
