# 1. Import the PayPal SDK client that was created in `Set up Server-Side SDK`.
require_relative '../paypal_client'
include PayPalCheckoutSdk::Orders
module Samples
  module CaptureIntentExamples
  class CaptureOrder

    #2. Set up your server to receive a call from the client
    # This sample function performs payment capture on the order.
    # Pass the approved order ID as an argument to this function
    def capture_order (order_id, debug=false)
    request = OrdersCaptureRequest::new(order_id)
    request.prefer("return=representation")
    #3. Call PayPal to capture an order
    begin
      response = PayPalClient::client.execute(request)
      #4. Save the capture ID to your database. Implement logic to save capture to your database for future reference.
    rescue => e
      puts e.result
      #5. Handle errors, if any.
    end
    if debug
      puts "Status Code: " + response.status_code.to_s
      puts "Status: " + response.result.status
      puts "Order ID: " + response.result.id
      puts "Intent: " + response.result.intent
      puts "Links:"
      for link in response.result.links
      # This could also be named link.rel or link.href, but method is a reserved keyword for Ruby. Avoid using link.method.
      puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
      end
      puts "Capture Ids: "
      for purchase_unit in response.result.purchase_units
        for capture in purchase_unit.payments.captures
          puts "\t #{capture.id}"
        end
      end
      puts "Buyer:"
      buyer = response.result.payer
      puts "\tEmail Address: #{buyer.email_address}\n\tName: #{buyer.name.full_name}\n\tPhone Number: #{buyer.phone.phone_number.national_number}"
      end
    return response
    end
  end
  end
end
# This driver function invokes the capture order function.
# Replace the order ID value with the approved order ID.
if __FILE__ == $0
  Samples::CaptureIntentExamples::CaptureOrder::new::capture_order('REPLACE-WITH-APPORVED-ORDER-ID', true)
end