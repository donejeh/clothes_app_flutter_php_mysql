<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\DB;
use App\Supportchat;
use App\Profile;
use Auth;
use Mail;
use App\Mail\KycEmail;
use App\Kyc;
use App\User;
use App\UserDetail;
use App\ReferralLog;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\Log;
// address genearion 
use App\Btcmugavari;
use App\Ethmugavari;
use App\Usdtmugavari;

use App\Btdmugavari;
use App\BtdTransaction;
use App\Userbtdmugavari;
use App\Userbtcmugavari;
use App\Userethmugavari;
use App\Userusdtmugavari;
use App\Traits\Bitcoin;
use App\Traits\Ethereum;

use App\Mail\KYCApprovedMail;
use App\Mail\KYCRejecteMail;

use App\Mail\DepositEmail;
use App\Mail\DepositPendingEmail;

class kycController extends Controller
{
    use Bitcoin, Ethereum;




    public function kyc()
    {


        $kycusers = DB::connection('mysql2')->table('kyc_details')
            ->join('users', 'kyc_details.user_id', '=', 'users.id')
            ->leftjoin('user_details', 'kyc_details.user_id', '=', 'user_details.user_id')
            ->select('users.username', 'kyc_details.*', 'users.email', 'user_details.mobile')
            ->where("kyc_details.status", 2)
            ->orderBy('kyc_details.id', 'desc')->paginate(30);

        $search_name = '';
        return view('userKyc/kyc', ['kycusers' => $kycusers, 'search_name' => $search_name]);
    }

    public function kycSearchList(Request $request)
    {
        $q = $statdate = $enddate = $trade_type = "";

        if (isset($request->searchitem)) {
            $q = $request->searchitem;
        }

        if (isset($request->trade_type)) {
            $trade_type = $request->trade_type;
        }

        $country = "";

        if (isset($request->country)) {
            $country = $request->country;
        }

        if (Input::get('q')) {
            $q = Input::get('q');
        }

        if (Input::get('trade_type')) {
            $trade_type = Input::get('trade_type');
        }

        if (Input::get('statdate')) {
            $statdate = Input::get('statdate');
        }

        if (Input::get('enddate')) {
            $enddate = Input::get('enddate');
        }

        $searchValues = preg_split('/\s+/', $q, -1, PREG_SPLIT_NO_EMPTY);

        if (isset($request->enddate, $request->statdate)) {
            if ($request->statdate != '') {
                $statdate = date('Y-m-d', strtotime($request->statdate));
            }
            if ($request->enddate != '') {
                $enddate = date('Y-m-d', strtotime($request->enddate));
            }

            if ($statdate > $enddate) {
                \Session::flash('error', 'Please select end date after your start date!');
                return redirect('kycData');
            }
        }

        $kycusers = DB::connection('mysql2')->table('kyc_details')
            ->join('users', 'kyc_details.user_id', '=', 'users.id')
            ->leftjoin('user_details', 'kyc_details.user_id', '=', 'user_details.user_id')
            ->join('countries', "kyc_details.country_id", "=", "countries.id")
            ->select('users.username', 'kyc_details.*', 'users.email', 'user_details.mobile')
            ->where(function ($query) use ($statdate, $enddate) {
                if ($statdate != '' && $enddate != '') {
                    $query->whereDate('kyc_details.created_at', '>=', $statdate);
                    $query->whereDate('kyc_details.created_at', '<=', $enddate);
                }
            })
            ->where(function ($query) use ($searchValues) {
                if ($searchValues != '') {
                    foreach ($searchValues as $value) {
                        $query->orWhere('users.username', 'like', "%{$value}%");
                        $query->orWhere('kyc_details.city', 'like', "%{$value}%");
                    }
                }
            })
            ->where(function ($query) use ($country) {
                if ($country != "") {
                    $query->where('countries.id', $country);
                }
            })
            ->where(function ($query) use ($trade_type) {
                if ($trade_type != 0) {
                    $query->where('kyc_details.status', $trade_type);
                } else {
                    $query->whereIn("kyc_details.status", [1, 2, 3]);
                }
            })
            ->orderBy('kyc_details.id', 'desc')
            ->paginate(15)->setPath('');

        $pagination = $kycusers->appends(array('q' => $q, 'statdate' => $statdate, 'enddate' => $enddate, 'trade_type' => $trade_type));

        return view('userKyc/kyc', ['kycusers' => $kycusers, 'search_name' => $q, 'statdate' => $statdate, 'enddate' => $enddate, 'trade_type' => $trade_type])->withQuery($q);
    }

    public function kycdetails($id)
    {
        $kycusers = Kyc::with('user')->where('id', $id)->orderBy('id', 'desc')->first();
        $countries = \DB::connection('mysql2')->table('countries')->select("id", "name")->get()->toArray();

        Kyc::where(["id" => $id, "status" => 2])->update(["admin_view" => 1]);

        if (is_object($kycusers)) {
            return view('userKyc/kycdetails', ['users' => $kycusers, 'countries' => $countries]);
        }
    }

    public function kycupdate(Request $request)
    {
        $kycData = ['status' => $request->status];

        $rules = [
            'kyc_id'   => 'required',
            'status' => 'required'
        ];

        if ($request->status == 3) {
            $rules["reason"] = "required";
            $kycData["reason"] = $request->reason;
        }

        $this->validate($request, $rules);

        $kyc = Kyc::where('id', $request->kyc_id)->first();


        if (is_object($kyc)) {
            if ($request->status == 1) {
                $btcaddress = $this->btcaddress($kyc->user_id);
                $eth        = $this->ethaddress($kyc->user_id);
                $usdt       = $this->usdtaddress($kyc->user_id);
                $this->fiatBalance($kyc->user_id);
            }
            $update = kyc::where('id', $kyc->id)->update($kycData);
            if ($update) {
                $user = \App\User::where("id", $kyc->user_id)->first();

                $details = [
                    "name" => $user ? $user->username : "",
                    "email" => $user ? $user->email : "",
                    "content" => ""
                ];

                $is_data = UserDetail::where('user_id', $kyc->user_id)->count();
                if ($is_data > 0) {
                    $update = UserDetail::where('user_id', $kyc->user_id)->update(['iskycverification' => $request->status]);
                } else {
                    $insert = new UserDetail();
                    $insert->user_id = $kyc->user_id;
                    $insert->iskycverification = $request->status;
                    $insert->save();
                }
                if ($request->status == 1) {
                    $details["content"] = "Your KYC has been approved";

                    $this->kycNotify($details, "approved");

                    $user = User::on('mysql2')->where('id', $kyc->user_id)->first();

                    Log::info($user);
                    //add 5000 welcome bonus
                    //if($user->btd_balance ==null){
                    //Log::info($user->btd_balance);

                    $user->btd_balance = $user->btd_balance + 5000.0;
		 
                    $userRef = User::find($user->referral_by);
		     $userRef->btd_balance = $userRef->btd_balance + 1000.0;
		     $userRef->save();
		     Log::info($userRef);

		     Log::info( $userRef->btd_balance);

                    if ($user->save()) {

                        $btd = new Userbtdmugavari;
                        $btd->setConnection('mysql2');
                        $btd->user_id = $user->id;
                        $btd->address  = $user->username;
                        $btd->balance = $user->btd_balance ? $user->btd_balance : 0;
                        $btd->status = 1;
                        $btd->available_balance = $user->btd_balance ? $user->btd_balance : 0;
                        $btd->save();

                        // $btdA = new App\Btdmugavari;
                        ///$btdA->user_id = $user->id;
                        //$btdA->address  = $user->username;
                        //$btdA->balance = $user->btd_balance ? $user->btd_balance : 0 ;
                        //$btdA->status = 1;
                        //$btdA->available_balance = $user->btd_balance ? $user->btd_balance : 0 ;
                        //$btdA->save();


                        $btdt = new BtdTransaction;
                        $btdt->setConnection('mysql2');
                        $btdt->uid = $user->id;
                        $btdt->txtype  = "received";
                        $btdt->txid = $this->generateReferralId();
                        $btdt->from_addr = "admin";
                        $btdt->to_addr = $user->username;
                        $btdt->amount = $user->btd_balance;
                        $btdt->status = 1;
                        $total = $user->btd_balance ? $user->btd_balance : 0;
                        $crypto_amount = array(
                            'crypto_amount' => number_format($total, 8, '.', '')
                        );

                        $currency = array(
                            'currency' => 'BTD'
                        );

                        $user_status = array(
                            'user_status' => "Pending"
                        );

                        \Mail::to($user->email)->send(new DepositPendingEmail($crypto_amount, $currency, $user_status));
                    }
                    //Log::info($user->btd_balance);
                    //}

                    $code = Crypt::decryptString($user->referral_id);
                    
                     //  $userRef->save()) 

                            $btd = Userbtdmugavari::where("user_id", $userRef->id)->first();
                            $btd->setConnection('mysql2');
                            $btd->user_id = $userRef->id;
                            $btd->address  = $userRef->username;
                            $btd->balance = $userRef->btd_balance ? $userRef->btd_balance : 0;
                            $btd->status = 1;
                            $btd->available_balance = $userRef->btd_balance ? $userRef->btd_balance : 0;
                            $btd->save();


                            $btdt = BtdTransaction::where("uid", $userRef->id)->first();
                            $btdt = new BtdTransaction;
                            $btdt->uid = $userRef->id;
                            $btdt->txtype  = "received";
                            $btdt->txid = $this->generateReferralId();
                            $btdt->from_addr = "admin";
                            $btdt->to_addr = $userRef->username;
                            $btdt->amount = $userRef->btd_balance;
                            $btdt->status = 1;
                            $total = $userRef->btd_balance ? $userRef->btd_balance : 0;
                            $crypto_amount = array(
                                'crypto_amount' => number_format($total, 8, '.', '')
                            );

                            $currency = array(
                                'currency' => 'BTD'
                            );

                            $user_status = array(
                                'user_status' => "Pending"
                            );

                            \Mail::to($userRef->email)->send(new DepositPendingEmail($crypto_amount, $currency, $user_status));
                   



                        $refData = [
                            "user_id" => $userRef->id,
                            "ref_by" => $user->id,
                            "message" => "1000BTD Referral Bonus By " . $user->username,
                        ];

                        $newUserData = [
                            "user_id" => $user->id,
                            "ref_by" => $userRef->id,
                            "message" => "5000BTD Signup Bonus By " . $user->username,

                        ];

                        ReferralLog::on('mysql2')->create($refData);
                        ReferralLog::on('mysql2')->create($newUserData);
                    }



                    \Session::flash('status', 'KYC approved Successfully');
                } else {
                    $details["reason"] = $kycData["reason"];

                    $this->kycNotify($details, "rejected");
                    \Session::flash('status', 'KYC rejected');
                }
            }
        } else {
            \Session::flash('status', 'Invalide Date');
        }
        return redirect()->back();
    }

    private function kycNotify($details, $action)
    {
        $emailResponse = [
            "name" => $details["name"],
            "email" => $details["email"],
            "content" => ""
        ];

        if ($action == "approved") {
            $emailResponse["content"] = $this->parseTemplateBody("kyc_approved_email", $details);

            \Mail::to($details['email'])->send(new KYCApprovedMail($emailResponse));
        } else if ($action == "rejected") {
            $emailResponse["content"] = $this->parseTemplateBody("kyc_rejected_email", $details);

            \Mail::to($details['email'])->send(new KYCRejecteMail($emailResponse));
        }
    }

    protected function btcaddress($user_id)
    {
        $data = Btcmugavari::where('user_id', $user_id)->first();
        if (!is_object($data)) {
            $btc =  $this->createaddress_btc();
            $btcaddress = $btc->address;
            $narchandru = Crypt::encrypt($btc->publickey . "," . $btc->wif . "," . $btc->privatekey);
            $btcsave = new Btcmugavari();
            $btcsave->user_id = $user_id;
            $btcsave->address = $btcaddress;
            $btcsave->narchandru = $narchandru;
            $btcsave->save();
            $btcsave = new Userbtcmugavari();
            $btcsave->user_id = $user_id;
            $btcsave->address = $btcaddress;
            $btcsave->save();
            return true;
        } else {
            return true;
        }
    }

    protected function ethaddress($user_id)
    {
        $data = Ethmugavari::where('user_id', $user_id)->first();
        if (!is_object($data)) {
            $eth        = $this->eth_user_address_create();
            $ethaddress = strtolower($eth['address']);
            $narchandru = Crypt::encrypt($eth['privatekey']);
            $ethsave = new Ethmugavari();
            $ethsave->user_id = $user_id;
            $ethsave->address = $ethaddress;
            $ethsave->narchandru = $narchandru;
            $ethsave->save();
            $ethsave = new Userethmugavari();
            $ethsave->user_id = $user_id;
            $ethsave->address = $ethaddress;
            $ethsave->save();
            return true;
        } else {
            return true;
        }
    }

    protected function usdtaddress($user_id)
    {
        $data = Usdtmugavari::where('user_id', $user_id)->first();
        if (!is_object($data)) {
            $eth        = $this->eth_user_address_create();
            $ethaddress = strtolower($eth['address']);
            $narchandru = Crypt::encrypt($eth['privatekey']);
            $ethsave = new Usdtmugavari();
            $ethsave->user_id = $user_id;
            $ethsave->address = $ethaddress;
            $ethsave->narchandru = $narchandru;
            $ethsave->save();
            $ethsave = new Userusdtmugavari();
            $ethsave->user_id = $user_id;
            $ethsave->address = $ethaddress;
            $ethsave->save();
            return true;
        } else {
            return true;
        }
    }

    protected function check_tag()
    {
        //destination tag
        $destination_tag = rand(100000, 999999);
        $is_data = Userxrpmugavari::where('tag', $destination_tag)->count();
        if ($is_data == 0) {
            return $destination_tag;
        } else {
            return $this->check_tag();
        }
    }

    public function kycupdatedata(Request $request)
    {
        $kyc_id = $request->input('kyc_id');
        $status = $request->input('status');
        $uid = $request->input('uid');

        $email = strip_tags($request->input('email'));
        if ($email != '') {
            //check user email id
            $is_user_data = User::on('mysql2')->where('id', '!=', $uid)->where('email', $email)->first();
            if (is_object($is_user_data)) {
                \Session::flash('status', 'Email ID already exist!');
                return redirect()->back();
                exit();
            }
        }

        if ($status != 0) {
            if ($status == 1) {
                $kyc_verify = 1;
            } elseif ($status == 2) {
                $kyc_verify = 0;
            } else {
                $kyc_verify = 2;
            }
            $update_kyc_status = Kyc::on('mysql2')->where('kyc_id', $kyc_id)->update(['status' => $status]);
            $update_user_status = User::on('mysql2')->where('id', $uid)->update(['kyc_verify' => $kyc_verify]);
            if ($update_user_status) {
                $phone = strip_tags($request->input('phone'));
                $address = strip_tags($request->input('address'));

                if (empty($phone)) {
                    $phone = NULL;
                }
                if (empty($address)) {
                    $address = NULL;
                }
                $profile = new Profile;
                $profile->setConnection('mysql2');

                $profiles = $profile->where(['uid' => $uid])->count();
                if ($profiles > 0) {
                    $profile->where('uid', '=', $uid)->update(['phone' => $phone, 'address' => $address]);
                } else {
                    $profile->uid = $uid;
                    $profile->phone = $phone;
                    $profile->address = $address;
                    $profile->save();
                }


                $messages = array(
                    'message' => "Rejected"
                );
                if ($status == 1) {
                    $messages = array(
                        'message' => "Approved"
                    );
                }

                //User notify
                \Mail::to($user->email)->send(new KycEmail($messages));

                $kycusers = Kyc::on('mysql2')->where('kyc_id', '=', $kyc_id)->first();
                \Session::flash('status', 'KYC Status Updated Successfully.');
                return redirect("kyc_details/$kyc_id");
            }
        } else {
            \Session::flash('status', 'Please update status as "Accept/Reject"');
            return redirect("kyc_details/$kyc_id");
        }
    }

    private function findReferralIdUser($referralId)
    {
        $matchedUser = "";

        if ($referralId) {
            $users = User::all()->toArray();

            if ($users) {
                foreach ($users as $user) {
                    $decrypt = null;

                    if ($user["referral_code"]) {
                        $decrypt = $user["referral_code"];
                    }

                    if ($decrypt == $referralId) {
                        $matchedUser = $user;
                    }
                }
            }
        }

        return $matchedUser;
    }
    private function generateReferralId()
    {
        $prefix = "BFD";
        $digits = 15;

        return $prefix . rand(pow(10, $digits - 1), pow(10, $digits) - 1);
    }


    public function fiatBalance($userId)
    {
        $userData = \App\UserDetail::where("user_id", $userId)->first();

        if ($userData) {
            $currency = (new \App\Country)->findByCurrency($userData->country);

            if ($currency) {
                $modelCls = $this->getClass($currency);

                $data = $modelCls::on('mysql2')->where(["user_id" => $userId, "currency" => strtolower($currency)])->first();

                if (!$data) {
                    $model = new \App\Fiatmugavari;
                    $model->setConnection('mysql2');
                    $model->user_id = $userId;
                    $model->currency = strtolower($currency);
                    $model->balance = 0;
                    $model->available_balance = 0;
                    $model->escrow_balance = 0;
                    $model->deposit_pending = 0;
                    $model->withdraw_pending = 0;
                    $model->save();
                }
            }
        }
    }
}
