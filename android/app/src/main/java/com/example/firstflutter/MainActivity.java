package com.example.firstflutter;

import android.os.Bundle;

import com.example.firstflutter.database.ContactDatabase;
import com.example.firstflutter.model.Contact;
import com.google.gson.Gson;

import java.util.List;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private final static String CHANNEL = "example.channel.dev/contacts";
    ContactDatabase contactDatabase;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);


        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

                final Map<String, Object> arguments = methodCall.arguments();

                contactDatabase = ContactDatabase.getDatabase(getApplication());

                if (methodCall.method.equals("saveContact")) {

                    String firstName = (String) arguments.get("firstName");
                    String lastName = (String) arguments.get("lastName");
                    String phoneNumber = (String) arguments.get("phoneNumber");

                    Contact contact = new Contact(firstName, lastName, phoneNumber);

                    contactDatabase.contactDao().createContact(contact);
                    contactDatabase.contactDao().deleteAll();


                } else if (methodCall.method.equals("listContacts")) {

                    Gson gson = new Gson();

                    List<Contact> list = contactDatabase.contactDao().listContacts();
                    String json = gson.toJson(list);
                    result.success(json);

                }else if (methodCall.method.equals("deleteContacts")){
                    final Map<String, List<String>> selectedContactIds = methodCall.arguments();
                    List<String> contactIds = selectedContactIds.get("ids");
                   for(String contactId:contactIds){
                       contactDatabase.contactDao().deleteById(Long.valueOf(contactId));
                   }



                } else {
                    result.notImplemented();
                }
            }
        });
    }


}
