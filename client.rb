require 'httpclient'
require 'uri'
require 'json'

#url = 'http://mrcp3.amivoicethai.com:14800/recognize'
url = 'https://mrcp3.amivoicethai.com:14801/recognize'
query = {
#  'd' => "grammarFileNames=-AmiDnnThaiMobile16k_BaseEngine",
  'd' => "grammarFileNames=-AmiDnnThaiTelephony8k_BaseEngine",
  'r' => "JSON",
  'u' => "0923F38B75C79B21E94CBB10DB37D111806304CE0221B82CF1B796B1BC80180F",
}
audio_filename = ARGV.shift
if not File.exist? audio_filename and File.extname(audio_filename) != '.wav'
  puts "Agument error"
  puts "Usage: {$0} audio-filename"
  puts "File format should be .wav"
  exit(1)
end
query_string = query.map{|k,v| "#{k}=#{URI.encode(v)}"}.join('&')

client = HTTPClient.new
#Uncomment below line to print communication between server and client
#client.debug_dev = $stderr
#Uncomment below line to avoid certification error
#client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
res = client.post("#{url}?#{query_string}", :body => open(audio_filename, 'rb').read)
if HTTP::Status.successful?(res.code)
  puts res.headers
  result = JSON.load(res.body)
  puts JSON.pretty_generate(result)
end
