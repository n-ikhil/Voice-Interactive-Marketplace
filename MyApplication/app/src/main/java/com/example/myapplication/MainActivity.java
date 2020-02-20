package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.os.Build;
import android.provider.Settings;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.widget.Button;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.Locale;

public class MainActivity extends AppCompatActivity  implements
        AdapterView.OnItemSelectedListener {


    String lan="hi-IN";
    SpeechRecognizer mSpeechRecognizer;
    Intent mSpeechRecognizerIntent;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        checkPermission();
        Spinner spinner = (Spinner) findViewById(R.id.planets_spinner);
        spinner.setOnItemSelectedListener(this);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
                R.array.planets_array, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);


        final TextView editText = findViewById(R.id.textbox);
        mSpeechRecognizer = SpeechRecognizer.createSpeechRecognizer(this);




//            change();

        mSpeechRecognizer.setRecognitionListener(new RecognitionListener() {
            @Override
            public void onReadyForSpeech(Bundle bundle) {

            }

            @Override
            public void onBeginningOfSpeech() {

            }

            @Override
            public void onRmsChanged(float v) {

            }

            @Override
            public void onBufferReceived(byte[] bytes) {

            }

            @Override
            public void onEndOfSpeech() {

            }

            @Override
            public void onError(int i) {

            }

            @Override
            public void onResults(Bundle bundle) {
                //getting all the matches
                ArrayList<String> matches = bundle
                        .getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);

                //displaying the first match
                if (matches != null)
                    editText.setText(matches.get(0));
            }

            @Override
            public void onPartialResults(Bundle bundle) {

            }

            @Override
            public void onEvent(int i, Bundle bundle) {

            }
        });

        final  Button bt=(Button)findViewById(R.id.button);

        findViewById(R.id.button).setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                switch (motionEvent.getAction()) {
                    case MotionEvent.ACTION_UP:
                        mSpeechRecognizer.stopListening();
                        editText.setHint("You will see input here");
                        bt.setBackgroundColor(Color.BLUE);
                        break;

                    case MotionEvent.ACTION_DOWN:
                        mSpeechRecognizer.startListening(mSpeechRecognizerIntent);
                        editText.setText("");
                        editText.setHint("Listening...");
                        bt.setBackgroundColor(Color.RED);
                        break;
                }
                return false;
            }
        });
    }


    private void checkPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!(ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED)) {
                Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                        Uri.parse("package:" + getPackageName()));
                startActivity(intent);
                finish();
            }
        }
    }

    public void change(){
//        String languagePref = lan;
        switch (lan)
        {
            case "Hindi" : lan="hi-IN";break;
            case "Kannada": lan="kn-IN";break;
            case "Telugu" :lan="te-IN";break;
            case "Bengali" : lan="bn-IN";break;
            case "Marathi": lan="mr-IN";break;
            case "Urdu" :lan="ur-IN";break;
            case "Gujarati" : lan="gu-IN";break;
            case "Tamil": lan="ta-IN";break;
            case "Malayalam" :lan="ml-IN";break;
            default: lan="en-IN";break;
        }
        String languagePref = lan;
//        Toast.makeText(getApplicationContext(),"hearing cnahegdlan " +lan, Toast.LENGTH_LONG).show();
        mSpeechRecognizerIntent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        mSpeechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE,languagePref);
        mSpeechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_PREFERENCE, languagePref);
        mSpeechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_ONLY_RETURN_LANGUAGE_PREFERENCE, languagePref);
        Toast.makeText(getApplicationContext(),"hearing in  " +lan, Toast.LENGTH_LONG).show();
    }
    @Override
    public void onItemSelected(AdapterView<?> arg0, View arg1, int pos, long id) {
//        Toast.makeText(getApplicationContext(),lan , Toast.LENGTH_LONG).show();
            lan=getResources().getStringArray(R.array.planets_array)[pos];
//            Toast.makeText(getApplicationContext(),lan, Toast.LENGTH_LONG).show();
            Log.d("MyActivity","Clicked new"+lan);
            change();
    }
    @Override

    public void onNothingSelected(AdapterView<?> arg0) {
        // TODO Auto-generated method stub
    }

//    public class SpinnerActivity extends Activity implements AdapterView.OnItemSelectedListener {
//
//
//        public void onItemSelected(AdapterView<?> parent, View view,
//                                   int pos, long id) {
//            // An item was selected. You can retrieve the selected item using
//            lan=(String)parent.getItemAtPosition(pos);
//            Toast.makeText(getApplicationContext(),lan, Toast.LENGTH_LONG).show();
//            Log.d("MyActivity","Clicked new"+lan);
////            Toast.makeText(getApplicationContext(),country[position] , Toast.LENGTH_LONG).show();
//        }
//
//        public void onNothingSelected(AdapterView<?> parent) {
//            // Another interface callback
//        }
//    }

}