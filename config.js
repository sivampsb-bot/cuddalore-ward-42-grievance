// Supabase Settings → API பகுதியில் உள்ள Project URL மற்றும் anon public key சேர்க்கவும்.
const SUPABASE_URL='https://qiwwahmdvuwzyukagofz.supabase.co';
const SUPABASE_ANON_KEY='sb_publishable_-vcKKqtdqzptEEvlExjk6A_ZmSe5I9S';
window.WARD42={client:SUPABASE_URL.startsWith('http')?supabase.createClient(SUPABASE_URL,SUPABASE_ANON_KEY):null};
