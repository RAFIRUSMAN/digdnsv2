require 'resolv'

class DnsController < ApplicationController
  def lookup
    domain = params[:domain]
    record_type = params[:record_type]

    if domain.blank?
      render json: { result: "Please enter a domain." }
      return
    end

    begin
      output = []
      output << "id #{rand(10000..99999)}"
      output << "opcode QUERY"
      output << "rcode NOERROR"
      output << "flags QR RD RA"
      output << ";QUESTION"
      output << "#{domain}. IN #{record_type}"
      output << ";ANSWER"

      case record_type
      when "A"
        records = Resolv::DNS.open { |dns| dns.getaddresses(domain) }
        records.each do |record|
          output << "#{domain}. 300 IN A #{record}"
        end
      when "MX"
        records = Resolv::DNS.open { |dns| dns.getresources(domain, Resolv::DNS::Resource::IN::MX) }
        records.each do |record|
          output << "#{domain}. 300 IN MX #{record.preference} #{record.exchange}"
        end
      when "NS"
        records = Resolv::DNS.open { |dns| dns.getresources(domain, Resolv::DNS::Resource::IN::NS) }
        records.each do |record|
          output << "#{domain}. 300 IN NS #{record.name}"
        end
      when "CNAME"
        records = Resolv::DNS.open { |dns| dns.getresources(domain, Resolv::DNS::Resource::IN::CNAME) }
        records.each do |record|
          output << "#{domain}. 300 IN CNAME #{record.name}"
        end
      else
        output << "Unsupported record type."
      end

      output << ";AUTHORITY"
      output << ";ADDITIONAL"

      render json: { result: output.join("\n") }
    rescue => e
      render json: { result: "Error: #{e.message}" }
    end
  end
end
