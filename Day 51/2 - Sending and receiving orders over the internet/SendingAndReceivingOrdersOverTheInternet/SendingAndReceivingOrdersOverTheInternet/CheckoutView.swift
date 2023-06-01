//
//  CheckoutView.swift
//  SendingAndReceivingOrdersOverTheInternet
//
//  Created by James Armer on 01/06/2023.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
              return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            
        } catch {
            print("Checkout failed.")
        }
    }
    
    /*
     Just like when we were downloading data using URLSession, uploading is also done asynchronously.
     
     Now modify the Place Order button to this:
     
     Button("Place Order") {
     placeOrder()
     }
     .padding()
     That code won’t work, and Swift will be fairly clear why: it calls an asynchronous function from a function that does not support concurrency. What it means is that our button expects to be able to run its action immediately, and doesn’t understand how to wait for something – even if we wrote await placeOrder() it still wouldn’t work, because the button doesn’t want to wait.
     
     Previously I mentioned that onAppear() didn’t work with these asynchronous functions, and we needed to use the task() modifier instead. That isn’t an option here because we’re executing an action rather than just attaching modifiers, but Swift provides an alternative: we can create a new task out of thin air, and just like the task() modifier this will run any kind of asynchronous code we want.
     
     In fact, all it takes is placing our await call inside a task, like this:
     
     Button("Place Order") {
     Task {
     await placeOrder()
     }
     }
     And now we’re all set – that code will call placeOrder() asynchronously just fine. Of course, that function doesn’t actually do anything just yet, so let’s fix that now.
     */
    
    /*
     Inside placeOrder() we need to do three things:

     Convert our current order object into some JSON data that can be sent.
     Tell Swift how to send that data over a network call.
     Run that request and process the response.
     The first of those is straightforward, so let’s get it out of the way. We’ve made the Order class conform to Codable, which means we can use JSONEncoder to archive it by adding this code to placeOrder():

     guard let encoded = try? JSONEncoder().encode(order) else {
         print("Failed to encode order")
         return
     }
     */
    
    /*
     The second step means using a new type called URLRequest, which is like a URL except it gives us options to add extra information such as the type of request, user data, and more.

     We need to attach the data in a very specific way so that the server can process it correctly, which means we need to provide two extra pieces of data beyond just our order:

     The HTTP method of a request determines how data should be sent. There are several HTTP methods, but in practice only GET (“I want to read data”) and POST (“I want to write data”) are used much. We want to write data here, so we’ll be using POST.
     The content type of a request determines what kind of data is being sent, which affects the way the server treats our data. This is specified in what’s called a MIME type, which was originally made for sending attachments in emails, and it has several thousand highly specific options.
     So, the next code for placeOrder() will be to create a URLRequest object, then configure it to send JSON data using a HTTP POST request. We can then use that to upload our data using URLSession, and handle whatever comes back.

     Of course, the real question is where to send our request, and I don’t think you really want to set up your own web server in order to follow this tutorial. So, instead we’re going to use a really helpful website called https://reqres.in – it lets us send any data we want, and will automatically send it back. This is a great way of prototyping network code, because you’ll get real data back from whatever you send.

     Add this code to placeOrder() now:

     let url = URL(string: "https://reqres.in/api/cupcakes")!
     var request = URLRequest(url: url)
     request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     request.httpMethod = "POST"

     */
    
    /*
     That first line contains a force unwrap for the URL(string:) initializer, which means “this returns an optional URL, but please force it to be nonoptional.” Creating URLs from strings might fail because you inserted some gibberish, but here I hand-typed the URL so I can see it’s always going to be correct – there are no string interpolations in there that might cause problems.

     At this point we’re all set to make our network request, which we’ll do using a new method called URLSession.shared.upload() and the URL request we just made. So, go ahead and add this to placeOrder():

     do {
         let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
         // handle the result
     } catch {
         print("Checkout failed.")
     }
     */
    
    /*
     Now for the important work: we need to read the result of our request for times when everything has worked correctly. If something went wrong – perhaps because there was no internet connection – then our catch block will be run, so we don’t have to worry about that here.

     Because we’re using the ReqRes.in, we’ll actually get back the same order we sent, which means we can use JSONDecoder to convert that back from JSON to an object.

     To confirm everything worked correctly we’re going to show an alert containing some details of our order, but we’re going to use the decoded order we got back from ReqRes.in. Yes, this ought to be identical to the one we sent, so if it isn’t it means we made a mistake in our coding.

     Showing an alert requires properties to store the message and whether it’s visible or not, so please add these two new properties to CheckoutView now:

     @State private var confirmationMessage = ""
     @State private var showingConfirmation = false
     We also need to attach an alert() modifier to watch that Boolean, and show an alert as soon as its true. Add this modifier below the navigation title modifiers in CheckoutView:

     .alert("Thank you!", isPresented: $showingConfirmation) {
         Button("OK") { }
     } message: {
         Text(confirmationMessage)
     }
     And now we can finish off our networking code: we’ll decode the data that came back, use it to set our confirmation message property, then set showingConfirmation to true so the alert appears. If the decoding fails – if the server sent back something that wasn’t an order for some reason – we’ll just print an error message.

     Add this final code to placeOrder(), replacing the // handle the result comment:

     let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
     confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
     showingConfirmation = true
     With that final code in place our networking code is complete, and in fact our app is complete too. If you try running it now you should be able to select the exact cakes you want, enter your delivery information, then press Place Order to see an alert appear!

     We’re done! Well, I’m done – you still have some challenges to complete!
     */
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
