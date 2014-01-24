package jp.co.uniontool.whs2;

import jp.co.uniontool.le.WhsHelper;
import jp.co.uniontool.receiveddata.PqrstData;
import jp.co.uniontool.receiveddata.RriAverageData;
import jp.co.uniontool.receiveddata.RriPeakData;
import jp.co.uniontool.receiveddata.SerializableReceivedData;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class DeviceControlActivity extends Activity {
	public static final String EXTRAS_DEVICE_NAME = "DEVICE_NAME";
	public static final String EXTRAS_DEVICE_ADDRESS = "DEVICE_ADDRESS";

	private TextView mConnectionState;
	private TextView mPqrst;
	private TextView mRri;
	private TextView mTemperature;
	private TextView mAccelerationX;
	private TextView mAccelerationY;
	private TextView mAccelerationZ;
	private String mDeviceAddress;
	private BluetoothLeService mBluetoothLeService;

	private final ServiceConnection mServiceConnection = new ServiceConnection() {

		@Override
		public void onServiceConnected(ComponentName componentName, IBinder service) {
			mBluetoothLeService = ((BluetoothLeService.LocalBinder) service).getService();
			if (!mBluetoothLeService.initialize()) {
				finish();
			}
			mBluetoothLeService.connect(mDeviceAddress);
		}

		@Override
		public void onServiceDisconnected(ComponentName componentName) {
			mBluetoothLeService = null;
		}
	};

	private final BroadcastReceiver mGattUpdateReceiver = new BroadcastReceiver() {
		@Override
		public void onReceive(Context context, Intent intent) {
			final String action = intent.getAction();
			if (BluetoothLeService.ACTION_GATT_CONNECTED.equals(action)) {
				updateConnectionState(R.string.connected);
				invalidateOptionsMenu();
			} else if (BluetoothLeService.ACTION_GATT_DISCONNECTED.equals(action)) {
				updateConnectionState(R.string.disconnected);
				invalidateOptionsMenu();
				clearUI();
			} else if (BluetoothLeService.ACTION_GATT_SERVICES_DISCOVERED.equals(action)) {
				mBluetoothLeService.displayGattServices(true);
			} else if (BluetoothLeService.ACTION_DATA_AVAILABLE_MEASURE.equals(action)) {
				displayData((SerializableReceivedData) intent.getSerializableExtra(WhsHelper.INTENT_RECEIVED_OBJ));
			}
		}
	};

	private void clearUI() {
		mPqrst.setText("");
        mRri.setText("");
        mTemperature.setText("");
        mAccelerationX.setText("");
        mAccelerationY.setText("");
        mAccelerationZ.setText("");
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_device_control);

        final Intent intent = getIntent();
        mDeviceAddress = intent.getStringExtra(EXTRAS_DEVICE_ADDRESS);

        ((TextView) findViewById(R.id.device_address)).setText(mDeviceAddress);
        mConnectionState = (TextView) findViewById(R.id.connection_state);
        mPqrst = (TextView) findViewById(R.id.pqrst);
        mRri = (TextView) findViewById(R.id.rri);
        mTemperature = (TextView) findViewById(R.id.temperature);
        mAccelerationX = (TextView) findViewById(R.id.acceleration_x);
        mAccelerationY = (TextView) findViewById(R.id.acceleration_y);
        mAccelerationZ = (TextView) findViewById(R.id.acceleration_z);
        
		getButtonSettingActivity().setOnClickListener(new PushSettingActivityListener());

        getActionBar().setDisplayHomeAsUpEnabled(true);
	}

    @Override
    protected void onResume() {
        super.onResume();
        Intent gattServiceIntent = new Intent(this, BluetoothLeService.class);
        bindService(gattServiceIntent, mServiceConnection, BIND_AUTO_CREATE);
        registerReceiver(mGattUpdateReceiver, makeGattUpdateIntentFilter());
        if (mBluetoothLeService != null) {
            mBluetoothLeService.connect(mDeviceAddress);
            mBluetoothLeService.displayGattServices(true);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        mBluetoothLeService.displayGattServices(false);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(mGattUpdateReceiver);
        unbindService(mServiceConnection);
        mBluetoothLeService = null;
    }

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case android.R.id.home:
			onBackPressed();
			return true;
		}
		return super.onOptionsItemSelected(item);
	}

	Button getButtonSettingActivity() {
		return (Button) findViewById(R.id.button_setting_activity);
	}

	class PushSettingActivityListener implements View.OnClickListener {
		@Override
		public void onClick(View v) {
			showSettingActivity();
		}
	}

	private void showSettingActivity() {
		Intent intent = new Intent(this, DeviceSettingActivity.class);
		startActivity(intent);
	}

	private void updateConnectionState(final int resourceId) {
		runOnUiThread(new Runnable() {
			@Override
			public void run() {
				mConnectionState.setText(resourceId);
			}
		});
	}

	private void displayData(final SerializableReceivedData data) {
		if (data != null) {
			if (data instanceof PqrstData) {
				mPqrst.setText(Integer.toString(data.getEcg()));
			} else if (data instanceof RriAverageData) {
				mRri.setText(Integer.toString(data.getEcg()));
			} else if (data instanceof RriPeakData) {
				mRri.setText(Integer.toString(data.getEcg()));
			}
			mTemperature.setText(String.format("%.2f",data.getTemperature()));
			mAccelerationX.setText(String.format("%.3f",data.getAccelerationX()));
			mAccelerationY.setText(String.format("%.3f",data.getAccelerationY()));
			mAccelerationZ.setText(String.format("%.3f",data.getAccelerationZ()));
		}
	}
	
    private static IntentFilter makeGattUpdateIntentFilter() {
        final IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(BluetoothLeService.ACTION_GATT_CONNECTED);
        intentFilter.addAction(BluetoothLeService.ACTION_GATT_DISCONNECTED);
        intentFilter.addAction(BluetoothLeService.ACTION_GATT_SERVICES_DISCOVERED);
        intentFilter.addAction(BluetoothLeService.ACTION_DATA_AVAILABLE_MEASURE);
        return intentFilter;
    }
}
